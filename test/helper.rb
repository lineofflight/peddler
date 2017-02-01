if RUBY_ENGINE == 'ruby'
  require 'simplecov'

  SimpleCov.start do
    add_filter '/test/'
  end
end

require 'minitest/autorun'
begin
  require 'pry'
rescue LoadError
end
