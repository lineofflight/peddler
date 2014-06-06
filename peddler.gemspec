# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'peddler/version'

Gem::Specification.new do |gem|
  gem.name        = 'peddler'
  gem.version     = Peddler::VERSION
  gem.platform    = Gem::Platform::RUBY
  gem.authors     = ['Hakan Ensari']
  gem.email       = ['hakanensari@me.com']
  gem.homepage    = 'http://github.com/hakanensari/peddler'
  gem.summary     = %q{Wraps the Amazon MWS APIs}
  gem.description = %q{A Ruby interface to the Amazon MWS API}

  gem.files         = Dir.glob('lib/**/*') + %w(LICENSE README.md)
  gem.test_files    = Dir.glob('test/**/*')
  gem.require_paths = ['lib']

  gem.add_dependency 'jeff', '~> 1.0'
  gem.add_dependency 'multi_xml', '~> 0.5.0'
  gem.add_dependency 'nokogiri', '~> 1.6.2.1'
  gem.add_development_dependency 'minitest', '~> 5.0'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'yard'

  gem.required_ruby_version = '>= 1.9'
end
