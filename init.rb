# require 'experimental/modules_in_render_hierarchy'

require 'lib/extensions/active_record'
require 'lib/extensions/model_reader'

# Specific requires here.
#
if defined?(Rails) && Rails.respond_to?(:version) && Rails.version >= '3.0.0'
  require 'lib/view_models/base_rails_3'
else
  require 'lib/view_models/base_rails_2'
  require 'lib/view_models/view_rails_2'
end

require 'lib/view_models'
require 'lib/view_models/render_options'
require 'lib/view_models/controller_extractor'
require 'lib/view_models/path_store'
require 'lib/view_models/base'
require 'lib/view_models/view'

require 'lib/helpers/view'
require 'lib/helpers/rails'
require 'lib/helpers/collection'

# TODO AbstractController?
#
ActionController::Base.send :include, ViewModels::Helpers::Rails
ActionView::Base.send       :include, ViewModels::Helpers::Rails