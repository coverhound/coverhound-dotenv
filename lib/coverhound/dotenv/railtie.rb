require "rails"
require "rake"

require_relative "config"
require_relative "patch/dotenv"

module Coverhound
  module Dotenv
    class Railtie < Rails::Railtie
      def load
        ::Dotenv.overload(
          Coverhound::Dotenv.config.dotenv(Rails.env)
        )
      end

      def self.load
        instance.load
      end

      config.before_configuration do
        load
      end

      rake_tasks do
        Kernel.load File.expand_path("../../../tasks/coverhound-dotenv.rake", __FILE__)
      end
    end
  end
end
