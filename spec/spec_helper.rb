$:.unshift File.expand_path '../../lib', __FILE__

require 'minitest/autorun'
begin
  require 'minitest/pride'
  require 'pry'
rescue LoadError
end

# https://github.com/geemus/excon/issues/142#issuecomment-8531521
Excon.defaults[:nonblock] = false if RUBY_PLATFORM == 'java'

require 'peddler'
