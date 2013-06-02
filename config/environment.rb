# Load the rails application
require File.expand_path('../application', __FILE__)

Dir[Rails.root.join("lib/app/**/*.rb")].each {|f| require f}
require "datatypes.rb"
require "validators.rb"
  
# Initialize the rails application
TecfilerAr::Application.initialize!
