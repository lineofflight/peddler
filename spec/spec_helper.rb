$:.unshift(File.expand_path('../../lib', __FILE__))
require 'peddler'
require 'minitest/autorun'
require 'minitest/pride'
begin
  require 'pry'
rescue LoadError
end
