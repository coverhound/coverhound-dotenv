require "test_helper"
require "coverhound/dotenv/command/validate"

describe Coverhound::Dotenv::Validate do
  subject = Coverhound::Dotenv::Validate.new

  before do
    subject.stubs(read_dev_dotenv: <<~DOTENV)
      FOO=1
      BAR=2
    DOTENV
  end

  describe "when environment variables are missing" do
    before do
      ENV.delete("FOO")
      ENV.delete("BAR")
    end

    it "fails" do
      assert_raises(Coverhound::Dotenv::ValidationError) { subject.call }
    end
  end

  describe "when NO environment variables are missing" do
    before do
      ENV["FOO"] = "1"
      ENV["BAR"] = "2"
    end

    it "passes" do
      subject.call
    end
  end
end
