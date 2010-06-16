# Makes certain AR Model methods available to the view model.
#
# Useful when the model is an AR Model.
#
module ViewModels
  module Extensions
    module ActiveRecord
      
      # For AR3, also delegate to_key to the model.
      #
      delegate :to_key, :to => :model
            
    end
  end
end