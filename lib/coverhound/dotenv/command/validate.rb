require "dotenv"

module Coverhound::Dotenv
  class ValidationError < StandardError
    def initialize(keys = [])
      super <<~MESSAGE
        Validation of os environment failed!
        The following variables are missing from the environment:
        #{keys.join("\n")}
      MESSAGE
    end
  end

  class Validate
    def self.call
      new.call
    end

    def call
      missing = dev_env_keys - ENV.keys
      raise ValidationError, missing unless missing.empty?
    end

    private

    def dev_env_keys
      @dev_env_keys ||= ::Dotenv::Parser.call(read_dev_dotenv).keys
    end

    def read_dev_dotenv
      EncryptedDotenv.new(
        Coverhound::Dotenv.config.dotenv("development")
      ).read
    end
  end
end
