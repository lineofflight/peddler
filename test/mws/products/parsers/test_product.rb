require 'parser_helper'
require 'mws/products/parsers/product'

class ProductParserTest < ParserTest
  def setup
    node = fixture_from_cassette('offer_listings_test/test_get_lower_for_sku').xpath('//xmlns:Product')
    @product = MWS::Products::Parsers::Product.new(node)
  end

  def test_identifiers
    assert_kind_of MWS::Products::Parsers::Identifiers, @product.identifiers
    assert @product.identifiers.document.any?
  end
end
