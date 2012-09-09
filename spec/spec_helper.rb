$:.unshift File.expand_path '../../lib', __FILE__

require 'minitest/autorun'
require 'minitest/pride'

require 'peddler'

begin
  require 'pry'
rescue LoadError
end
