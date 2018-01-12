require "dotenv"
require_relative "encrypted_dotenv"
require_relative "chamber"

module Coverhound
  module Dotenv
    class Read
      def self.call(filename)
        new(filename).call
      end

      attr_reader :filename

      def initialize(filename)
        @filename = filename
      end

      def call
        if encrypted? && file?
          Coverhound::Dotenv::EncryptedDotenv.new(filename).read || raise(Errno::ENOENT)
        elsif chamber?
          Coverhound::Dotenv::Chamber.new(app_name: app_name, env: env, region: region).env
        end
      end

      private

      def file?
        File.file?(filename)
      end

      def encrypted?
        filename.end_with?(".enc")
      end

      def chamber?
        filename.end_with?(".chamber")
      end

      def app_name
        Coverhound::Dotenv.config.app_name
      end

      def env
        filename[%r{([^/]+).chamber\z}, 1]
      end

      def region
        Coverhound::Dotenv.config.region
      end
    end
  end
end

::Dotenv::Environment.class_eval do
  alias_method :old_read, :read
  def read
    Coverhound::Dotenv::Read.call(@filename) || old_read
  end
end
