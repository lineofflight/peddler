require 'parser_helper'
require 'mws/products/parsers/product'

class ProductParserTest < ParserTest
  def setup
    node = fixture('products/lowest_offer_listings_for_sku').xpath('//xmlns:Product')
    @product = MWS::Products::Parsers::Product.new(node)
  end

  def test_identifiers
    assert_kind_of MWS::Products::Parsers::Identifiers, @product.identifiers
  end

  def test_lowest_offer_listings
    assert_kind_of MWS::Products::Parsers::LowestOfferListings, @product.lowest_offer_listings
  end
end
