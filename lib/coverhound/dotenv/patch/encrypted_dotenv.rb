if Gem::Dependency.new("rails", "~> 5.2").match?("rails", Rails::VERSION::STRING)
  require "active_support/encrypted_file"
else
  require_relative "polyfill/encrypted_file"
end

module Coverhound::Dotenv
  class EncryptedDotenv < ActiveSupport::EncryptedFile
    def initialize(content_path)
      super(
        content_path: content_path,
        key_path: File.expand_path("../dotenv.key", content_path),
        env_key: "RAILS_DOTENV_SECRET",
      )
    end

    def edit
      change do |tmp_file|
        system("#{ENV['EDITOR']} #{tmp_file}")
      end
    end
  end
end
