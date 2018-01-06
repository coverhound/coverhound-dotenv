module Coverhound::Dotenv
  module Command
    module Migrate
      class PrintDotenv
        def self.call(mapping:, path:)
          new(mapping: mapping, path: path).call
        end

        def initialize(mapping:, path:)
          @mapping = mapping
          @path = path
        end

        attr_reader :mapping, :path

        def call
          File.open(path, "w") do |file|
            mapping.mapped.each do |_, env_key, value|
              file.puts "#{env_key}=#{value}"
            end
          end
        end
      end
    end
  end
end
