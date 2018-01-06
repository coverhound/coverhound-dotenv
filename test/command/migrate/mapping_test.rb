require "test_helper"
require "coverhound/dotenv/command/migrate/mapping"

describe Coverhound::Dotenv::Command::Migrate::Mapping do
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

  subject do
    Coverhound::Dotenv::Command::Migrate::Mapping.new(
      env: "development",
      settings: settings,
      path: tempfile.path
    )
  end

  before do
    File.write(tempfile.path, <<~MAPPING_FILE)
      twitter.key=
      twitter.secret.password=TWITTER_SECRET
      host=HOST
    MAPPING_FILE

    Coverhound::Dotenv::Command::Helper.stubs(:warn)
  end
  after { tempfile.close }

  describe "#mapped" do
    it "returns keys mapped to environment variables" do
      expected = [
        %w[twitter.secret.password TWITTER_SECRET bar],
        ["host", "HOST", nil]
      ]

      assert_equal(expected, subject.mapped)
    end
  end

  describe "#unmapped" do
    it "returns keys not mapped to environment variables" do
      expected = [["twitter.key", nil, "foo"]]
      assert_equal(expected, subject.unmapped)
    end
  end

  describe "side effects" do
    it "warns about unmapped values" do
    end

    it "warns about undefined values" do
    end
  end
end
