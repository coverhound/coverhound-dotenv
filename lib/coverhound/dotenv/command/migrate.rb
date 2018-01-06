require_relative "migrate/mapping"
require_relative "migrate/print_keys"
require_relative "migrate/print_dotenv"
require_relative "migrate/print_settings"

require "yaml"
require "tempfile"

module Coverhound::Dotenv
  module Command
    module Migrate
      MAPPING_PATH = "yaml-to.env.mapping".freeze
      SETTINGS_PATH = "config/settings.yml".freeze

      def self.call(env = "development")
        settings = YAML.load_file SETTINGS_PATH

        if File.file?(MAPPING_PATH)
          puts "Using existing mapping at #{MAPPING_PATH}"
        else
          PrintKeys.call(settings: settings, path: MAPPING_PATH)
        end

        system("#{ENV['EDITOR']} #{MAPPING_PATH}")

        mapping = Mapping.new(path: MAPPING_PATH, settings: settings, env: env)
        PrintDotenv.call(path: "#{env}.env", mapping: mapping)
        PrintSettings.call(path: "new.settings.yml", mapping: mapping)
      end
    end
  end
end
