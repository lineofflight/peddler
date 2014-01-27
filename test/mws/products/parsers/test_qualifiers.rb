require 'parser_helper'
require 'mws/products/parsers/qualifiers'

class QualifiersParserTest < ParserTest

  def setup
    node = fixture_from_cassette('offer_listings_test/test_get_lower_for_sku').xpath('//xmlns:Qualifiers')
    @qualifiers = MWS::Products::Parsers::Qualifiers.new(node)
  end

  [ :item_condition, :item_subcondition,
    :fulfillment_channel, :seller_positive_feedback_rating].each do |method|
    define_method "test_#{method}" do
      assert_kind_of String, @qualifiers.public_send(method)
    end
  end

end
