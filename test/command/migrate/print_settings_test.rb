require "test_helper"
require "coverhound/dotenv/command/migrate/print_settings"

describe Coverhound::Dotenv::Command::Migrate::PrintSettings do
  subject = Coverhound::Dotenv::Command::Migrate::PrintSettings
  let(:tempfile) { Tempfile.new }
  after { tempfile.close }
  let(:mapped) do
    [
      ["host", "HOST", nil],
      ["twitter.key", "TWITTER_KEY", "foo"],
      ["twitter.secret.password", "TWITTER_SECRET", "bar"]
    ]
  end
  let(:unmapped) { [["twitter.timeout", nil, 30]] }
  let(:mapping) { stub("Mapping", mapped: mapped, unmapped: unmapped) }

  it "returns keys mapped to environment variables" do
    expected = <<~SETTINGS_FILE
      defaults: &defaults
        host: <%= ENV.fetch("HOST") %>
        twitter:
          key: <%= ENV.fetch("TWITTER_KEY") %>
          secret:
            password: <%= ENV.fetch("TWITTER_SECRET") %>
          timeout: 30

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
    SETTINGS_FILE

    subject.call(mapping: mapping, path: tempfile.path)
    assert_equal(expected, File.read(tempfile.path))
  end
end
