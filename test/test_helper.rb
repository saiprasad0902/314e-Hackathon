ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'simplecov'
SimpleCov.start

SimpleCov.profiles.define "my app" do
  load_profile "rails" # simplecov defaults
  add_filter "spec"    # don't include the spec directory
  add_filter "lib"     # only if an app doesn't have code in lib
end

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
