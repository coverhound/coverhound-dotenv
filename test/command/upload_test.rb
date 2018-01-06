require "test_helper"
require "coverhound/dotenv/config"
require "coverhound/dotenv/command/upload"

describe Coverhound::Dotenv::Command::Upload do
  vars = { "FOO" => "BAR", "BAZ" => "FALSE" }

  let(:subject) { Coverhound::Dotenv::Command::Upload }
  let(:app_name) { "dummy" }
  let(:env) { "upload" }

  before do
    Coverhound::Dotenv.configure do |config|
      config.app_name = app_name
    end
    STDIN.stubs(gets: "y")
    STDOUT.stubs(:puts)
  end

  describe "::call" do
    it "writes the environment variables to chamber" do
      vars.each do |key, value|
        Coverhound::Dotenv::Chamber.any_instance.expects(:write).with(key, value).once
      end

      Dir.chdir FIXTURE_PATH do
        subject.call(env)
      end
    end
  end
end
