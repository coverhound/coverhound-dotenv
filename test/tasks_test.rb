require "test_helper"

describe "ch:dotenv" do

  describe "show" do
    it "outputs the contents of the file" do
      STDOUT.expects(:puts).with(<<~BODY).once
        EXAMPLE=TRUE
      BODY
      run_task("show")
    end
  end

  describe "edit" do
    # no use testing a system call to EDITOR + file
  end

  describe "validate" do
    before do
      Object.any_instance.stubs(print: nil, puts: nil)
    end

    describe "when the environment doesn't contain the keys" do
      before { ENV.delete("EXAMPLE") }

      it "fails" do
        Object.any_instance.expects(:abort)
        run_task("validate")
      end
    end

    describe "when the environment variable is defined" do
      before { ENV["EXAMPLE"] = "TRUE" }

      it "passes" do
        run_task("validate")
      end
    end
  end

  def rake
    @rake ||= begin
      Rake::Application.new.tap do |r|
        Rake.application = r
        Rake.load_rakefile("tasks/coverhound-dotenv.rake")
        Rake::Task.define_task(:environment)
      end
    end
  end

  def run_task(name, *args)
    rake["ch:dotenv:#{name}"].invoke(*args)
  end
end
