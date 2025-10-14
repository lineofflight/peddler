# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("lib", __dir__))
require "peddler/version"

Gem::Specification.new do |gem|
  gem.name     = "peddler"
  gem.version  = Peddler::VERSION
  gem.summary  = "Amazon Selling Partner API (SP-API) in Ruby"
  gem.authors  = ["Hakan Ensari"]
  gem.email    = ["hakanensari@gmail.com"]
  gem.files    = Dir["lib/peddler/**/*.rb", "sig/peddler/**/*.rbs"].append("lib/peddler.rb", "sig/peddler.rbs", "LICENSE", "README.md")
  gem.homepage = "https://github.com/lineofflight/peddler"
  gem.license  = "MIT"

  gem.add_dependency("http", "~> 5.3")
  gem.add_dependency("nokogiri", "~> 1.0")
  gem.add_dependency("structure", "~> 4.1")
  gem.add_dependency("zeitwerk", "~> 2.6")
  gem.required_ruby_version = ">= 3.2"

  gem.metadata["rubygems_mfa_required"] = "true"
end
