module Coverhound
  module Dotenv
    class Config
      attr_accessor :region
      attr_writer :app_name

      def initialize
        @region = "us-west-1"
        @app_name = nil
      end

      def app_name
        @app_name || raise(<<~MSG)
          Must define app_name at the top of config/application.rb:
          Coverhound::Dotenv.configure do |config|
            config.app_name = "..."
          end
        MSG
      end

      def dotenv(env)
        dotenv_options[env]
      end

      def key
        root.join("config/environments/dotenv.key")
      end

      private

      def root
        Rails.root || Pathname.new(Dir.pwd)
      end

      def dotenv_options
        {
          development: root.join("config/environments/development.env.enc"),
          test: root.join("config/environments/test.env")
        }.tap { |h| h.default = "#{Rails.env}.chamber" }.with_indifferent_access
      end
    end

    class << self
      def config
        @config ||= Config.new
      end

      def configure
        yield config
      end
    end
  end
end
