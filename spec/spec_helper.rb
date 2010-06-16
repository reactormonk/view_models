require 'rubygems'

rails_version = ARGV.find { |e| e =~ /rails_version=.*/ }
rails_version = rails_version.split('=').last.to_i rescue 2

if rails_version == 3
  gem 'rails',         '>= 3.0.0.beta4'
else
  gem 'rails',         '~> 2.3'
end

require 'spec'

# require 'rails'
require 'active_support'
require 'action_controller'

$:.unshift File.dirname(__FILE__)
$:.unshift File.join(File.dirname(__FILE__), '../lib')

require File.join(File.dirname(__FILE__), '../init')

require 'spec_helper_extensions'
include SpecHelperExtensions