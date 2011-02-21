# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'peddler/version'

Gem::Specification.new do |s|
  s.name        = 'peddler'
  s.version     = Peddler::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Paper Cavalier']
  s.email       = ['code@papercavalier.com']
  s.homepage    = 'https://rubygems.org/gems/peddler'
  s.summary     = %q{A Ruby wrapper to the Amazon Inventory Management API}
  s.description = %q{Peddler is a Ruby wrapper to the Amazon Inventory Management API.}

  s.rubyforge_project = 'peddler'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'activesupport', '>= 2.3.2'
  s.add_dependency 'i18n'
  s.add_development_dependency 'rspec', '~> 2.5.0'
  s.add_development_dependency 'vcr', '~> 1.6.0'
  s.add_development_dependency 'webmock', '~> 1.6.2'
  if RUBY_VERSION.include? '1.9'
    s.add_development_dependency("ruby-debug19", "~> 0.11.0")
  end
end
