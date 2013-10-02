require 'parser_helper'
require 'mws/orders/parsers/shipping_address'

class ShippingAddressParserTest < ParserTest
  def setup
    node = fixture('orders').xpath('//xmlns:ShippingAddress').first
    @address = MWS::Orders::Parsers::ShippingAddress.new(node)
  end

  def test_name
    assert_kind_of String, @address.name
  end

  def test_address_lines
    assert_kind_of Array, @address.address_lines
    @address.address_lines.each do |line|
      assert_kind_of String, line
    end
  end

  def test_city
    assert_kind_of String, @address.city
  end

  def test_state_or_region
    assert_kind_of String, @address.state_or_region
  end

  def test_postal_code
    assert_kind_of String, @address.postal_code
  end

  def test_country_code
    assert_kind_of String, @address.country_code
  end
end
