require "set"

module Coverhound::Dotenv
  module Command
    module Migrate
      class PrintKeys
        class Keys < Set
          ENVIRONMENTS = %w[
            defaults
            test
            development
            staging
            preprod
            production
          ].freeze

          def <<(key)
            super key.sub(/^(#{ENVIRONMENTS.join("|")})\./, "")
          end
        end

        HELP_MESSAGE = <<~MESSAGE
          # Please add environment variable mappings below
          # Example:
          # foo.bar.baz=FOO_BAR_BAZ
          # foo.bar.bing=FOO_BAR_BING
        MESSAGE

        def self.call(settings:, path:)
          @keys ||= new(settings: settings, path: path).call
        end

        def initialize(settings:, path:)
          @settings = settings
          @output = File.open(path, "w")
          @keys = Keys.new
        end

        def call
          output.puts HELP_MESSAGE
          crawl(settings)
          keys.sort.each { |key| output.puts "#{key}=" }
          output.close
        end

        private

        attr_reader :keys, :settings, :output

        def crawl(node, path = [])
          case node
          when Hash  then node.each { |key, value| crawl(value, path + [key]) }
          when Array then node.each_with_index { |value, index| crawl(value, path + [index]) }
          else keys << path.join(".")
          end
        end
      end
    end
  end
end
