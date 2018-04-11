namespace "ch:dotenv" do
  desc "Upload Dotenv File"
  task :upload, [:env] do |t, args|
    require "coverhound/dotenv/command/upload"
    Coverhound::Dotenv::Command::Upload.call(args[:env])
  end

  desc "Migrate to Dotenv"
  task :migrate, [:env] do |t, args|
    require "coverhound/dotenv/command/migrate"
    Coverhound::Dotenv::Command::Migrate.call(args[:env])
  end

  desc "Edit Dotenv File"
  task :edit do
    Coverhound::Dotenv::EncryptedDotenv.new(
      Coverhound::Dotenv.config.dotenv(:development)
    ).edit
  end

  desc "Show Dotenv File"
  task :show do
    puts Coverhound::Dotenv::EncryptedDotenv.new(
      Coverhound::Dotenv.config.dotenv(:development)
    ).read
  end

  desc "Generate Dotenv File"
  task :generate do
    key_path = Coverhound::Dotenv.config.key
    if File.exist? key_path
      puts "Using key at #{key_path}"
    else
      File.write(key_path, ActiveSupport::EncryptedFile.generate_key)
      puts "Created key at #{key_path}"
    end

    dotenv_path = Coverhound::Dotenv.config.dotenv(:development)
    abort "File exists at #{dotenv_path}" if File.exist? dotenv_path
    Coverhound::Dotenv::EncryptedDotenv.new(dotenv_path).write("EXAMPLE=TRUE\n")
  end

  desc "Validate existence of environment variables against .env"
  task validate: :environment do
    require "coverhound/dotenv/command/validate"

    print "Validating presence of environment variables against development.env... "
    begin
      Coverhound::Dotenv::Validate.call
    rescue => e
      abort(e.to_s)
    end
    puts "Done!"
  end
end
