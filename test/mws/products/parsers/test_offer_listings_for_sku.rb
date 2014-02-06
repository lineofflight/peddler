require 'parser_helper'
require 'mws/products/parsers/offer_listings_for_sku'

class OfferListingsForSKUParserTest < ParserTest
  def setup
    node = fixture('products/lowest_offer_listings_for_sku').xpath('//xmlns:GetLowestOfferListingsForSKUResult')
    @offer_listings = MWS::Products::Parsers::OfferListingsForSKU.new(node)
  end

  def test_has_offer_listings_for_sku
    refute_empty @offer_listings.to_a
    @offer_listings.each { |offer_listing| assert_kind_of MWS::Products::Parsers::OfferListingForSKU, offer_listing }
  end
end
