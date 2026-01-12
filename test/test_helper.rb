ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"

# ViewComponent test helpers are needed in both modes
require "view_component/test_case"

if ENV["SKIP_DB"] == "1"
  # Lightweight boot for pure ViewComponent tests (no ActiveRecord, no fixtures)
  require "minitest/autorun"
else
  # Full Rails test helpers (will attempt DB connections and maintain test schema)
  require "rails/test_help"

  module ActiveSupport
    class TestCase
      # Run tests in parallel with specified workers
      parallelize(workers: :number_of_processors)

      # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
      fixtures :all

      # Add more helper methods to be used by all tests here...
    end
  end
end
