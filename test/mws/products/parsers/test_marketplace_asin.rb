require 'parser_helper'
require 'mws/products/parsers/marketplace_asin'

class MarketplaceASINParserTest < ParserTest
  def setup
    node = fixture('products/lowest_offer_listings_for_sku').xpath('//xmlns:MarketplaceASIN')
    @identifier = MWS::Products::Parsers::MarketplaceASIN.new(node)
  end

  def test_marketplace_id
    assert_kind_of String, @identifier.marketplace_id
  end

  def test_asin
    assert_kind_of String, @identifier.asin
  end
end
