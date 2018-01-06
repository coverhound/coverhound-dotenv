namespace "ch:dotenv" do
  desc "Validate existence of environment variables against .env"
  task :validate_environment do
    key = File.read(Coverhound::Dotenv.config.key)

    on roles(:all) do
      with(rails_env: fetch(:rails_env), rails_dotenv_secret: key) do
        within release_path do
          execute :rake, "ch:dotenv:validate"
        end
      end
    end
  end

  after "bundler:install", :validate_environment
end
