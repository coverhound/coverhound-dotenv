require "test_helper"

describe Coverhound::Dotenv::Chamber do
  subject do
    Coverhound::Dotenv::Chamber.new(
      app_name: "chamber",
      env: "test",
      region: "us-east-2"
    )
  end

  let(:app_env) { "chamber-test" }
  let(:expected_env) do
    { "CHAMBER_AWS_REGION" => "us-east-2", "CHAMBER_KMS_KEY_ALIAS" => "chamber-test" }
  end

  let(:stdout) { "Output" }
  let(:stderr) { "" }
  let(:status_code) { stub(success?: true) }
  let(:open3_return) { [stdout, stderr, status_code] }

  before do
    Open3.stubs(capture3: open3_return)
  end

  describe "#env" do
    it "runs the command" do
      Open3.expects(:capture3).with do |env, *args|
        env == expected_env && args == ["chamber", "exec", app_env, "--", "env"]
      end.once.returns(open3_return)
      assert_equal stdout, subject.env
    end
  end

  describe "#write" do
    it "runs the command" do
      Open3.expects(:capture3).with do |env, *args|
        env == expected_env && args == ["chamber", "write", app_env, "key", "value"]
      end.once.returns(open3_return)
      assert_equal stdout, subject.write("key", "value")
    end
  end

  describe "when a command returns a non-zero status code" do
    let(:status_code) { stub(success?: false) }
    let(:stderr) { "Error" }

    it "fails" do
      assert_raises(Coverhound::Dotenv::Chamber::ShellError, stderr) do
        subject.env
      end
    end
  end
end
