# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'peddler/version'

Gem::Specification.new do |s|
  s.name        = 'peddler'
  s.version     = Peddler::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Hakan Ensari']
  s.email       = ['hakan.ensari@papercavalier.com']
  s.homepage    = 'http://github.com/hakanensari/peddler'
  s.summary     = %q{Wraps the Amazon Marketplace Web Service API}
  s.description = %q{A wrapper to the Amazon Marketplace Web Service (MWS) API}

  s.add_development_dependency 'rake',  '~> 0.9'
  s.add_development_dependency 'rspec', '~> 2.9'
  s.add_runtime_dependency 'aws-url',   '~> 0.1.1'
  s.add_runtime_dependency 'faraday',   '~> 0.8.0'
  s.add_runtime_dependency 'nokogiri',  '~> 1.5'

  s.files         = Dir.glob('lib/**/*') + %w(LICENSE README.md)
  s.test_files    = Dir.glob('spec/**/*')
  s.require_paths = ['lib']
end
