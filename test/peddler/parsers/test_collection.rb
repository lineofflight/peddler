require 'helper'
require 'peddler/parsers/collection'

class PeddlerCollectionParserTest < MiniTest::Test
  def test_is_enumerable
    assert_respond_to Peddler::Parsers::Collection.new(nil), :map
  end
end
