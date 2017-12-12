# frozen_string_literal: true

# Keep SimpleCov at top.
require 'simplecov'
SimpleCov.start do
  add_filter '/test/'
end

require 'backports/2.3.0/hash/dig'
require 'minitest/autorun'
require 'minitest/focus'
begin
  require 'pry'
rescue LoadError
end
