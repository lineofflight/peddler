require 'helper'
require 'peddler/parsers/model'
require 'nokogiri'

class PeddlerModelParserTest < MiniTest::Test
  def build(xml)
    document = Nokogiri(xml)
    Peddler::Parsers::Model.new(document)
  end

  def test_parses_money
    xml = <<-EOF
    <Price xmlns="example">
      <CurrencyCode>USD</CurrencyCode>
      <Amount>10.00</Amount>
    </Price>
    EOF
    model = build(xml)
    money = model.money_at_xpath('Price')
    assert_equal '$10.00', money.format
  end

  def test_parses_japanese_yen
    xml = <<-EOF
    <Price xmlns="example">
      <CurrencyCode>JPY</CurrencyCode>
      <Amount>1000.00</Amount>
    </Price>
    EOF
    model = build(xml)
    money = model.money_at_xpath('Price')
    assert_equal '¥1,000', money.format
  end

  def test_parses_truthy_value
    xml = <<-EOF
    <Bool xmlns="example">
      true
    </Bool>
    EOF
    model = build(xml)
    assert_equal true, model.boolean_at_xpath('Bool')

    xml = <<-EOF
    <Bool xmlns="example">
      Yes
    </Bool>
    EOF
    model = build(xml)
    assert_equal true, model.boolean_at_xpath('Bool')
  end

  def test_parses_falsy_value
    xml = <<-EOF
    <Bool xmlns="example>
      false
    </Bool>
    EOF
    model = build(xml)
    assert_equal false, model.boolean_at_xpath('Bool')

    xml = <<-EOF
    <Bool xmlns="example>
      No
    </Bool>
    EOF
    model = build(xml)
    assert_equal false, model.boolean_at_xpath('Bool')
  end

  def test_parses_attribute
    xml = <<-EOF
    <Attr xmlns="example" foo="bar">
      false
    </Attr>
    EOF
    document = Nokogiri(xml).xpath('//xmlns:Attr')
    model = Peddler::Parsers::Model.new(document)
    assert_equal 'bar', model.attribute('foo')
  end
end
