# Base Module for ViewModels.
#
# Note: Just the Rails 2 specific parts.
#
module ViewModels
  class Base
    
    # Make helper and helper_method available
    #
    include ActionController::Helpers
    
    class << self
      
      # Accesses the view to find a suitable template path.
      #
      def template_path_from view, options 
        template = view.find_template tentative_template_path(options)
        template && template.path
      end
      
    end
    
    # Make all the dynamically generated routes (restful routes etc.)
    # available in the view_model
    #
    ActionController::Routing::Routes.install_helpers self
    
    # Returns a view instance for render_xxx.
    #
    def view_instance
      View.new controller, master_helper_module
    end
    
  end
end