if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start :rails do
    add_filter "test"
  end
end

require File.expand_path("../../test/dummy/config/environment.rb", __FILE__)
require "rails/test_help"
require "minitest/spec"
require "mocha/mini_test"

FIXTURE_PATH = Pathname.new(File.expand_path("../fixtures", __FILE__))

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new
