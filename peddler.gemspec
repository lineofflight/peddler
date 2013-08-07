# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'peddler/version'

Gem::Specification.new do |gem|
  gem.name        = 'peddler'
  gem.version     = Peddler::VERSION
  gem.platform    = Gem::Platform::RUBY
  gem.authors     = ['Hakan Ensari', 'Ezekiel Templin']
  gem.email       = ['code@papercavalier.com']
  gem.homepage    = 'http://github.com/papercavalier/peddler'
  gem.summary     = %q{Wraps the Amazon Marketplace Web Service API}
  gem.description = %q{A wrapper to the Amazon Marketplace Web Service (MWS) API}

  gem.files         = Dir.glob('lib/**/*') + %w(LICENSE README.md)
  gem.test_files    = Dir.glob('test/**/*')
  gem.require_paths = ['lib']

  gem.add_dependency 'jeff', '~> 0.7.0'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'

  gem.required_ruby_version = '>= 1.9'
end
