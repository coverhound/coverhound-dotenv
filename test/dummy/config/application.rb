require_relative 'boot'

# Pick the frameworks you want:
require "action_controller/railtie"
require "action_view/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)
require "coverhound-dotenv"

module Dummy
  class Application < Rails::Application
    config.eager_load = false
    config.active_support.test_order = :random
  end
end

