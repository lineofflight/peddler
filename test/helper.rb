if RUBY_ENGINE == 'ruby'
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]

  SimpleCov.start do
    add_filter '/test/'
  end
end

require 'minitest/autorun'
begin
  require 'pry'
rescue LoadError
end
