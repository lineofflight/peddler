# frozen_string_literal: true

$LOAD_PATH.push(File.expand_path("lib", __dir__))
require "peddler/version"

Gem::Specification.new do |gem|
  gem.name     = "peddler"
  gem.version  = Peddler::VERSION
  gem.authors  = ["Hakan Ensari"]
  gem.email    = ["hakanensari@gmail.com"]
  gem.homepage = "https://github.com/hakanensari/peddler"
  gem.summary  = "The Amazon Selling Partner API (SP-API) in Ruby"
  gem.license  = "MIT"

  gem.files = Dir.glob("lib/**/*") + ["LICENSE", "README.md"]

  gem.add_dependency("http", ">= 5.0", "< 7.0")

  gem.required_ruby_version = ">= 3.2"
  gem.metadata["rubygems_mfa_required"] = "true"
end
