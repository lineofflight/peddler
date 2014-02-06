require 'parser_helper'
require 'mws/products/parsers/shipping_time'

class ShippingTimeParserTest < ParserTest
  def setup
    node = fixture('products/lowest_offer_listings_for_sku').xpath('//xmlns:ShippingTime')
    @shipping_time = MWS::Products::Parsers::ShippingTime.new(node)
  end

  def test_max
    assert_kind_of String, @shipping_time.max
  end
end
