require 'parser_helper'
require 'mws/products/parsers/identifiers'

class IdentfiersParserTest < ParserTest
  def setup
    node = fixture_from_cassette('offer_listings_test/test_get_lower_for_sku').xpath('//xmlns:Identifiers')
    @identifiers = MWS::Products::Parsers::Identifiers.new(node)
  end

  [:marketplace_id, :asin, :seller_id, :seller_sku].each do |method|
    define_method "test_#{method}" do
      assert_kind_of String, @identifiers.public_send(method)
    end
  end


end
