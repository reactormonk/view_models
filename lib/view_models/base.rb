# Base Module for ViewModels.
#
module ViewModels
  
  # Gets raised when render_as, render_the, or render_template cannot
  # find the named template, not even in the hierarchy.
  #
  class MissingTemplateError < StandardError; end
  
  # Base class from which all view_models inherit.
  #
  class Base
    
    attr_reader :model, :controller
    
    # Make helper and helper_method available
    #
    include ActionController::Helpers
    
    # Create a view_model. To create a view_model, you need to have a model (to present) and a context.
    # The context is usually a view or a controller.
    # Note: But doesn't need to be one :)
    # 
    def initialize model, context
      @model = model
      @controller = ControllerExtractor.new(context).extract
    end
    
    class << self
      
      def inherited subclass
        ViewModels::PathStore.install_in subclass
        super
      end
      attr_accessor :path_store
      
      include Extensions::ModelReader
      
      # Delegates method calls to the controller.
      #
      # Examples:
      #   controller_method :current_user
      #   controller_method :current_user, :current_profile  # multiple methods to be delegated
      #
      # In the view_model:
      #   self.current_user
      # will call
      #   controller.current_user
      #
      def controller_method *methods
        delegate *methods << { :to => :controller }
      end
      
      # Wrapper for add_template_helper in ActionController::Helpers, also
      # includes given helper in the view_model
      #
      # TODO extract into module
      #
      alias old_add_template_helper add_template_helper
      def add_template_helper helper_module
        include helper_module
        old_add_template_helper helper_module
      end
      
      # Returns the next view model class in the render hierarchy.
      #
      def next
        next_class = superclass
        raise MissingTemplateError.new if next_class == ViewModels::Base
        next_class
      end
      
      #
      #
      def render view, options
        store = self.path_store
        store.prepare view.path_key(options)
        result = view.render_for self, options
        store.save options if result
        result
      end
      
      # Return as render path either a stored path or a newly generated one.
      #
      def template_path key, options
        path_store[key] || generate_template_path_from(options)
      end
      
      protected
        
        # Returns the root of this view_models views with the template name appended.
        # e.g. 'view_models/some/specific/path/to/template'
        #
        def generate_template_path_from options
          File.join(generate_path_from(options), options.name)
        end
        
        # If the path is explicitly defined, return it, otherwise
        # generate a view model path from the class name.
        #
        def generate_path_from options
          options.path || view_model_path
        end
        
        # Returns the path from the view_model_view_paths to the actual templates.
        # e.g. "view_models/models/book"
        #
        # If the class is named
        #   ViewModels::Models::Book
        # this method will yield
        #   view_models/models/book
        #
        # Note: Remembers the result.
        #
        def view_model_path
          @view_model_path || @view_model_path = self.name.underscore
        end
        
    end # class << self
    
    # Delegate controller methods.
    #
    controller_method :logger, :form_authenticity_token, :protect_against_forgery?, :request_forgery_protection_token
    
    # Make all the dynamically generated routes (restful routes etc.)
    # available in the view_model
    #
    ActionController::Routing::Routes.install_helpers self
    
    # Renders the given view in the view_model's view root in the format given.
    #
    # Example:
    #   app/views/view_models/this/view_model/_partial.haml
    #   app/views/view_models/this/view_model/_partial.text.erb
    #
    # The following options are supported: 
    # * :format - Calling view_model.render_as('template') will render the haml
    #   partial, calling view_model.render_as('template', :format => :text) will render
    #   the text erb.
    # * All other options are passed on to the render call. I.e. if you want to specify locals you can call
    #   view_model.render_as(:partial, :locals => { :name => :value })
    # * If no format is given, it will render the default format, which is (currently) html.
    #
    def render_as name, options = {}
      options.extend(Extensions::RenderOptions).partial = name
      render options
    end
    # render_the is used for small parts.
    #
    # Example:
    # # If the view_model is called window, the following
    # # is more legible than window.render_as :menubar
    # * window.render_the :menubar
    #
    alias render_the render_as
    
    # TODO
    #
    def render_template name, options = {}
      options.extend(Extensions::RenderOptions).template = name
      render options
    end
    
    protected
      
      # TODO
      #
      def render options
        options.view_model = self
        view = view_instance_for options
        # metaclass.send(:define_method, :capture) do |*args, &block|
        #   view.capture *args, &block
        # end
        self.class.render view, options
      end
      
      # Creates a view instance with the given format.
      #
      # Examples:
      # * Calling view_instance_for :html will later render the haml
      #   template, calling view_instance_for :text will later render
      #   the erb.
      #
      def view_instance_for options
        view = View.new controller, master_helper_module
        format = format_for options
        view.template_format = format if format
        view
      end
      
      # Extracts the format from the options and returns it, or a saved one.
      #
      # Returns nil when no format option has been passed or no format is saved.
      #
      attr_accessor :template_format
      def format_for options
        self.template_format = options.delete(:format) || self.template_format
      end
      
  end
end