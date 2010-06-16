# require 'experimental/modules_in_render_hierarchy'

require 'extensions/active_record'
require 'extensions/model_reader'

# Specific requires here.
#
if defined?(Rails) && Rails.respond_to?(:version) && Rails.version >= '3.0.0'
  require 'view_models/base_rails_3'
else
  require 'view_models/base_rails_2'
  require 'view_models/view_rails_2'
end

require 'view_models'
require 'view_models/render_options'
require 'view_models/controller_extractor'
require 'view_models/path_store'
require 'view_models/base'
require 'view_models/view'

require 'helpers/view'
require 'helpers/rails'
require 'helpers/collection'

# TODO AbstractController?
#
ActionController::Base.send :include, ViewModels::Helpers::Rails
ActionView::Base.send       :include, ViewModels::Helpers::Rails