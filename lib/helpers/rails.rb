module ViewModels
  module Helpers
    module Rails
      
      mattr_accessor :specific_view_model_mapping
      self.specific_view_model_mapping = {}
      
      # Create a new view_model instance for the given model instance
      # with the given arguments.
      #
      # Note: Will emit an ArgumentError if the view model class doesn't support 2 arguments.
      #
      def view_model_for model, context = self
        view_model_class_for(model).new model, context
      end
      
      # Get the view_model class for the given model instance.
      #
      # Note: ViewModels are usually of class ViewModels::<ModelClassName>.
      #       (As returned by default_view_model_class_for)
      #       Override specific_mapping if you'd like to install your own.
      #
      # OR:   Override default_view_model_class_for(model) if
      #       you'd like to change the default.
      #
      def view_model_class_for model
        specific_view_model_class_for(model) || default_view_model_class_for(model)
      end
      
      # Returns the default view_model class for the given model instance.
      #
      # Default class name is:
      # ViewModels::<ModelClassName>
      #
      # Override this method if you'd like to change the _default_
      # model-to-view_model class mapping.
      #
      # Note: Will emit a NameError if a corresponding ViewModels constant cannot be loaded.
      #
      mattr_accessor :default_prefix
      self.default_prefix = 'ViewModels::'
      def default_view_model_class_for model
        (default_prefix + model.class.name).constantize
      end
      
      # Returns a specific view_model class for the given model instance.
      #
      # Override this method, if you want to return a specific
      # view model class for the given model.
      #
      # Note: Will emit a NameError if a corresponding ViewModels constant cannot be loaded.
      #
      def specific_view_model_class_for model
        result = specific_view_model_mapping[model.class]
        return unless result
        case result
        when Proc
          result.call model
        when String
          result.constantize
        when Class
          result
        else
          raise "Invalid value for specific view model mapping."
        end
      end
      
    end
  end
end
