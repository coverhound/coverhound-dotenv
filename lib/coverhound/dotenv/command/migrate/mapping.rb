require_relative "../helper"

module Coverhound::Dotenv
  module Command
    module Migrate
      class Mapping
        def initialize(env:, settings:, path:)
          @env = env
          @settings = settings
          mapping = create_mapping(path)

          @unmapped, @mapped = mapping.partition { |_, env_key| env_key.nil? }
          @undefined = mapping.select { |_, _, value| value.nil? }

          warn_unmapped
          warn_undefined
        end

        attr_reader :mapped, :unmapped

        private

        attr_reader :env, :settings

        def create_mapping(path)
          File.read(path).each_line.
            reject { |line| line =~ /\s*#/ }.
            map do |line|
              yaml_key, env_key = line.chomp.split("=")
              value = value_for(yaml_key)
              [yaml_key, env_key, value]
            end
        end

        def value_for(yaml_key)
          settings.dig(env, *yaml_key.split("."))
        end

        def warn_unmapped
          Helper.warn(<<~MESSAGE) unless unmapped.empty?

            WARNING
            No environment variable name provided for some YAML keys.
            The default behavior is to hard-code values for these.

            The following keys were hard-coded:
            #{unmapped.map(&:first).join(', ')}
          MESSAGE
        end

        def warn_undefined
          Helper.warn(<<~MESSAGE) unless @undefined.empty?

            WARNING
            No value found for the following YAML keys in #{env} environment:
            #{@undefined.map(&:first).join(', ')}
          MESSAGE
        end
      end
    end
  end
end
