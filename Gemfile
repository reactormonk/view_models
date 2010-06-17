# This gemfile is only needed for the specs.
#

rails_version = ARGV.find { |e| e =~ /rails_version=.*/ }
rails_version = rails_version.split('=').last.to_i rescue 2

if rails_version == 3
  gem 'rails', '>= 3.0.0.beta4'
else
  gem 'rails', '~> 2.3'
end