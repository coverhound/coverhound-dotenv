require "test_helper"
require "coverhound/dotenv/command/migrate/print_dotenv"

describe Coverhound::Dotenv::Command::Migrate::PrintDotenv do
  subject = Coverhound::Dotenv::Command::Migrate::PrintDotenv
  let(:tempfile) { Tempfile.new }
  after { tempfile.close }
  let(:mapped) do
    [
      [nil, "HOST", nil],
      [nil, "TWITTER_KEY", "foo"],
      [nil, "TWITTER_SECRET", "bar"]
    ]
  end
  let(:mapping) { stub("Mapping", mapped: mapped) }

  it "returns keys mapped to environment variables" do
    expected = <<~DOTENV_FILE
      HOST=
      TWITTER_KEY=foo
      TWITTER_SECRET=bar
    DOTENV_FILE

    subject.call(mapping: mapping, path: tempfile.path)
    assert_equal(expected, File.read(tempfile.path))
  end
end
