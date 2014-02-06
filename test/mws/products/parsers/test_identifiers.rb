require 'parser_helper'
require 'mws/products/parsers/identifiers'

class IdentifiersParserTest < ParserTest
  def setup
    node = fixture('products/lowest_offer_listings_for_sku').xpath('//xmlns:Identifiers')
    @identifiers = MWS::Products::Parsers::Identifiers.new(node)
  end

  def test_marketplace_asin
    assert_kind_of MWS::Products::Parsers::MarketplaceASIN, @identifiers.marketplace_asin
  end

  def test_sku_identifier
    assert_kind_of MWS::Products::Parsers::SKUIdentifier, @identifiers.sku_identifier
  end
end
