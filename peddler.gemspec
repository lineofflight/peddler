# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'peddler/version'

Gem::Specification.new do |s|
  s.name        = 'peddler'
  s.version     = Peddler::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Hakan Ensari']
  s.email       = ['hakan.ensari@papercavalier.com']
  s.homepage    = 'http://github.com/papercavalier/peddler'
  s.summary     = %q{A Ruby wrapper to the Amazon Inventory Management API}
  s.description = %q{Peddler is a Ruby wrapper to the Amazon Inventory Management API.}

  s.rubyforge_project = 'peddler'

  s.files         = `git ls-files`.split('\n')
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split('\n')
  s.executables   = `git ls-files -- bin/*`.split('\n').map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'activesupport', '>= 2.3.2'
  s.add_development_dependency 'rspec', '~> 2.0.0'
  s.add_development_dependency 'vcr', '~> 1.2.0'
  s.add_development_dependency 'webmock', '~> 1.4.0'
end
