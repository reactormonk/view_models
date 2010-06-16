# require 'experimental/modules_in_render_hierarchy'

# Version check and includes here

if true # ::RAILS_VERSION == 3 || Rails.respond_to?(:version) && Rails.version >= '3.0.0'
  gem 'rails', '>= 3.0'
else
  gem 'rails', '~> 2.3'
end

require 'extensions/active_record'
require 'extensions/model_reader'

require 'view_models'
require 'view_models/render_options'
require 'view_models/controller_extractor'
require 'view_models/path_store'
require 'view_models/base'
require 'view_models/view'

require 'helpers/view'
require 'helpers/rails'
require 'helpers/collection'

ActionController::Base.send :include, ViewModels::Helpers::Rails
ActionView::Base.send       :include, ViewModels::Helpers::Rails