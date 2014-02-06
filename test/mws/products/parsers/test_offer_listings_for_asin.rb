require 'parser_helper'
require 'mws/products/parsers/offer_listings_for_asin'

class OfferListingsForASINParserTest < ParserTest
  def setup
    node = fixture('products/lowest_offer_listings_for_asin').xpath('//xmlns:GetLowestOfferListingsForASINResult')
    @offer_listings = MWS::Products::Parsers::OfferListingsForASIN.new(node)
  end

  def test_has_offer_listings_for_asin
    refute_empty @offer_listings.to_a
    @offer_listings.each { |offer_listing| assert_kind_of MWS::Products::Parsers::OfferListingForASIN, offer_listing }
  end
end
