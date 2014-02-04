require 'parser_helper'
require 'mws/products/parsers/offer_listings'

class OfferListingsParserTest < ParserTest
  def setup
    node = fixture_from_cassette('offer_listings_test/test_get_lower_for_sku').xpath('//xmlns:GetLowestOfferListingsForSKUResult')
    @offer_listings = MWS::Products::Parsers::OfferListings.new(node)
  end

  def test_product
    assert_kind_of MWS::Products::Parsers::Product, @offer_listings.product
    assert @offer_listings.product.document.size > 0
  end
end
