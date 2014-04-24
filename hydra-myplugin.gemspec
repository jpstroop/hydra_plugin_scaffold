$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "hydra/myplugin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "hydra-myplugin"
  s.version     = Hydra::Myplugin::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of HydraMyplugin."
  s.description = "TODO: Description of HydraMyplugin."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.0.4"

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'yard'
end
