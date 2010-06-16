module ViewModels
  # View model Rails 2 specific view.
  #
  class View < ActionView::Base
    
    # Finds the template in the view paths at the given path, with its format.                                         
    #
    def find_template path                                                                                             
      view_paths.find_template path, template_format rescue nil                                                        
    end
    
  end
  
end