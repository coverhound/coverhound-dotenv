$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "coverhound/dotenv/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "coverhound-dotenv"
  s.version     = Coverhound::Dotenv::VERSION
  s.authors     = ["Bernardo Farah"]
  s.email       = ["ber@bernardo.me"]
  s.homepage    = "https://github.com/coverhound/coverhound-dotenv"
  s.summary     = "CoverHound's Dotenv with AWS"
  s.description = "CoverHound's Dotenv with AWS"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "railties", ">= 4.1.0", "< 5.3"
  s.add_dependency "dotenv", "~> 2.0"

  s.add_development_dependency "mocha"
end
