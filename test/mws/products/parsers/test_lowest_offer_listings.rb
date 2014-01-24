require 'parser_helper'
require 'mws/products/parsers/lowest_offer_listings'
require 'mws/products/parsers/lowest_offer_listing'

class LowestOfferListingsParserTest < ParserTest

  def setup
    node = fixture_from_cassette('offer_listings_test/test_get_lower_for_sku').xpath('//xmlns:LowestOfferListings')
    @lowest_offer_listings = MWS::Products::Parsers::LowestOfferListings.new(node)
  end

  def test_has_lowest_offer_listings
    refute_empty @lowest_offer_listings.to_a
    @lowest_offer_listings.each do |lowest_offer_listing|
      assert_kind_of MWS::Products::Parsers::LowestOfferListing, lowest_offer_listing
    end
  end
end
