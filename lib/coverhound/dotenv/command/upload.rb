require_relative "helper"
require "dotenv/parser"

module Coverhound::Dotenv
  module Command
    class Upload
      def self.call(env)
        new(env).call
      end

      def initialize(env)
        @file = "#{env}.env"
        @app_env = "#{app_name}-#{env}"
        @chamber = Chamber.new(
          app_name: config.app_name,
          env: env,
          region: config.region
        )
      end

      attr_reader :file, :app_env, :chamber

      def call
        check_file!
        confirm_env!
        env_vars.each { |key, value| chamber.write(key, value) }
      end

      private

      def check_file!
        if File.file?(file)
          puts "Using #{file} as .env for upload"
        else
          Helper.abort("No dotenv file found at #{file}")
        end
      end

      def confirm_env!
        puts "Writing to #{app_env} environment on AWS. OK?"
        answer = STDIN.gets
        exit unless answer =~ /\A\s*y/i
      end

      def env_vars
        Dotenv::Parser.call(File.read(file))
      end

      def config
        Coverhound::Dotenv.config
      end

      delegate :app_name, :region, to: :config
    end
  end
end
