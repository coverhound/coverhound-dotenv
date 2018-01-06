require "open3"

module Coverhound
  module Dotenv
    class Chamber
      class ShellError < StandardError; end

      attr_reader :app_env, :region

      def initialize(app_name:, env: Rails.env, region: "us-west-1")
        @app_env = "#{app_name}-#{env}"
        @region = region
      end

      def env
        exec "exec", "--", "env"
      end

      def write(key, value)
        exec "write", key, value
      end

      private

      def shell_env
        { "CHAMBER_AWS_REGION" => region, "CHAMBER_KMS_KEY_ALIAS" => app_env }
      end

      def exec(command, *args)
        stdout, stderr, status = Open3.capture3(
          shell_env, "chamber", command, app_env, *args
        )
        raise ShellError, stderr unless status.success?
        stdout
      end
    end
  end
end
