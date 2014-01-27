require 'parser_helper'
require 'mws/products/parsers/price'

class PriceParserTest < ParserTest
  def setup
    node = fixture_from_cassette('offer_listings_test/test_get_lower_for_sku').xpath('//xmlns:Price')
    @price = MWS::Products::Parsers::Price.new(node)
  end

  [:landed_price, :listing_price, :shipping].each do |method|
    define_method "test_#{method}" do
      assert_kind_of Money, @price.public_send(method)
    end
  end
end
