source 'http://rubygems.org'
gemspec
platform :jruby do
  gem 'jruby-openssl'
  gem 'minitest'
end
unless ENV['CI']
  gem 'guard-minitest'
  gem 'pry'
end
