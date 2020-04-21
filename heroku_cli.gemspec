# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "heroku_cli/version"

Gem::Specification.new do |spec|
  spec.name          = "heroku_cli"
  spec.version       = HerokuCLI::VERSION
  spec.authors       = ["Rasmus Bergholdt"]
  spec.email         = ["rasmus.bergholdt@gmail.com"]

  spec.summary       = %q{A tiny wrapper for Heroku CLI}
  spec.description   = %q{Wrap the Heroku CLI to make it more accessable from your ruby script}
  spec.homepage      = "https://github.com/Flightlogger/heroku_cli"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.0"
end
