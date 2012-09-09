$:.unshift File.expand_path '../../lib', __FILE__

require 'minitest/autorun'
begin
  require 'minitest/pride'
  require 'pry'
rescue LoadError
end

require 'peddler'
