source 'https://rubygems.org'

gem 'rails', '3.2.17'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails', '~> 2.0.1'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

# devise user authentication:
gem 'devise'

gem "prawn", "~> 0.12.0"

# twitter bootstrap:
gem "therubyracer"
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
# twitter-bootstrap-rails versioning appears brittle, lock to last known working version
gem "twitter-bootstrap-rails", "= 2.2.8"

group :test do
  # Pretty printed test output
  gem 'turn', '~> 0.9.4', :require => false
end

# Rspec
group :development, :test do
  gem "rspec-rails", ">= 2.4.1"
  gem 'factory_girl_rails'
end

# state_machine for reports workflow
gem 'state_machine'

# active admin:
gem 'activeadmin'
# sass-rails is required but already included
# gem 'sass-rails'
gem "meta_search", '>= 1.1.0.pre'
