require 'rubygems'
require 'bundler'

Bundler.setup

require 'spec'
require 'active_support'
require 'action_controller'

rails_version = ARGV.find { |e| e =~ /rails_version=.*/ }
rails_version = rails_version.split('=').last.to_i rescue 2
if rails_version == 3
  require 'rails'
end

require File.join(File.dirname(__FILE__), '../init')

require 'spec_helper_extensions'
include SpecHelperExtensions