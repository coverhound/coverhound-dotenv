require "test_helper"
require "coverhound/dotenv/command/migrate/print_keys"

describe Coverhound::Dotenv::Command::Migrate::PrintKeys do
  subject = Coverhound::Dotenv::Command::Migrate::PrintKeys
  let(:tempfile) { Tempfile.new }
  let(:settings) do
    { development: {
      twitter: {
        key: "foo",
        secret: { password: "bar" }
      },
      host: nil
    } }.with_indifferent_access
  end
  after { tempfile.close }

  it "returns keys mapped to environment variables" do
    expected = <<~MAPPING_FILE
      #{subject::HELP_MESSAGE}host=
      twitter.key=
      twitter.secret.password=
    MAPPING_FILE

    subject.call(settings: settings, path: tempfile.path)
    assert_equal(expected, File.read(tempfile.path))
  end
end
