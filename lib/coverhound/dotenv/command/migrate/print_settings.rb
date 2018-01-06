require "yaml"

module Coverhound::Dotenv
  module Command
    module Migrate
      class PrintSettings
        def self.call(mapping:, path:)
          new(mapping: mapping, path: path).call
        end

        def initialize(mapping:, path:)
          @mapping = mapping
          @path = path
          @hash = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
        end

        def call
          mapping.mapped.each do |yaml_key, env_key|
            add(yaml_key, env_value(env_key))
          end

          mapping.unmapped.each do |yaml_key, _, value|
            add(yaml_key, value)
          end

          write
        end

        private

        attr_reader :mapping, :path, :hash

        def add(yaml_key, value)
          *keys, last_key = yaml_key.split(".")
          final_hash = keys.inject(hash) { |memo, key| memo[key] }
          final_hash[last_key] = value
        end

        def write
          File.write(path, <<~YAML)
            defaults: &defaults
            #{indented_yaml}
            test:
              <<: *defaults

            development:
              <<: *defaults

            staging:
              <<: *defaults

            preprod:
              <<: *defaults

            production:
              <<: *defaults
          YAML
        end

        def indented_yaml
          hash.to_yaml.lines[1..-1].map { |line| "  #{line}" }.join
        end

        def env_value(env_key)
          "<%= ENV.fetch(\"#{env_key}\") %>"
        end
      end
    end
  end
end
