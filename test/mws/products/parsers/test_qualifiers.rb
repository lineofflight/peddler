require 'parser_helper'
require 'mws/products/parsers/qualifiers'

class QualifiersParserTest < ParserTest
  def setup
    node = fixture('products/lowest_offer_listings_for_sku').xpath('//xmlns:Qualifiers')
    @qualifiers = MWS::Products::Parsers::Qualifiers.new(node)
  end

  def test_item_condition
    assert_kind_of String, @qualifiers.item_condition
  end

  def test_item_subcondition
    assert_kind_of String, @qualifiers.item_subcondition
  end

  def test_fulfillment_channel
    assert_kind_of String, @qualifiers.fulfillment_channel
  end


  def test_seller_positive_feedback_rating
    assert_kind_of String, @qualifiers.seller_positive_feedback_rating
  end

  def test_shipping_time
    assert_kind_of MWS::Products::Parsers::ShippingTime, @qualifiers.shipping_time
  end
end
