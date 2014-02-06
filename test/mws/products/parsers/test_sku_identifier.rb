require 'parser_helper'
require 'mws/products/parsers/sku_identifier'

class SKUIdentifierParserTest < ParserTest
  def setup
    node = fixture('products/lowest_offer_listings_for_sku').xpath('//xmlns:SKUIdentifier')
    @identifier = MWS::Products::Parsers::SKUIdentifier.new(node)
  end

  def test_marketplace_id
    assert_kind_of String, @identifier.marketplace_id
  end

  def test_seller_id
    assert_kind_of String, @identifier.seller_id
  end

  def test_seller_sku
    assert_kind_of String, @identifier.seller_sku
  end
end
