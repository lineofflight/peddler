require 'helper'
require 'nokogiri'

class ParserTest < MiniTest::Test
  def fixture(type)
    file = File.expand_path("../fixtures/#{type}.xml", __FILE__)
    body = File.read(file)

    Nokogiri(body)
  end
end
