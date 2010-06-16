# Base Module for ViewModels.
#
# Note: Just the Rails 3 specific parts.
#
module ViewModels
  
  # Make helper and helper_method available
  #
  include AbstractController::Helpers
  
  class << self
    
    # Accesses the view to find a suitable template path.
    #
    def template_path_from view, options 
      template = view.find_template tentative_template_path(options)
      template && template.virtual_path
    end
    
  end
  
  # Make all the dynamically generated routes (restful routes etc.)
  # available in the view_model
  #
  Rails.application.routes.install_helpers self
  
  # Returns a view instance for render_xxx.
  #
  def view_instance
    View.new controller, self._helpers
  end
  
end