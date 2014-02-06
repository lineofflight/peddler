require 'helper'
require 'nokogiri'

# To suppress deprecation notice
I18n.enforce_available_locales = false

class ParserTest < MiniTest::Test
  def fixture(type)
    file = File.expand_path("../fixtures/#{type}.xml", __FILE__)
    body = File.read(file)

    Nokogiri(body)
  end

  def fixture_from_cassette(type, index = 0)
    file = File.expand_path("../fixtures/vcr_cassettes/#{type}.yml", __FILE__)
    doc = YAML.load_file(file)
    body = doc['http_interactions'][index]['response']['body']['string']

    Nokogiri(body)
  end
end
