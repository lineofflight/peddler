require 'parser_helper'
require 'mws/products/parsers/price'

class PriceParserTest < ParserTest
  def setup
    node = fixture('products/lowest_offer_listings_for_sku').xpath('//xmlns:Price')
    @price = MWS::Products::Parsers::Price.new(node)
  end

  def test_landed_price
    assert_kind_of Money, @price.landed_price
  end

  def test_listing_price
    assert_kind_of Money, @price.listing_price
  end

  def test_shipping
    assert_kind_of Money, @price.shipping
  end
end
