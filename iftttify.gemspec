$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "iftttify/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "iftttify"
  s.version     = Iftttify::VERSION
  s.authors     = ["Quan Sun"]
  s.email       = ["iftttify@qsun.me"]
  s.homepage    = "https://github.com/qsun/iftttify"
  s.summary     = "allow IFTTT to talk to our Rails app"
  s.description = "allow IFTTT to talk to our Rails app using wordpress xmlrpc protocol"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.6"

  s.add_development_dependency "sqlite3"
end
