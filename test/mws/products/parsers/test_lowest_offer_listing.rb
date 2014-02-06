require 'parser_helper'
require 'mws/products/parsers/lowest_offer_listing'

class LowestOfferListingParserTest < ParserTest

  def setup
    node = fixture('products/lowest_offer_listings_for_sku').xpath('//xmlns:LowestOfferListing')
    @lowest_offer_listing = MWS::Products::Parsers::LowestOfferListing.new(node)
  end

  def test_number_of_offer_listings_considered
    assert_kind_of Integer, @lowest_offer_listing.number_of_offer_listings_considered
  end

  def test_seller_feedback_count
    assert_kind_of Integer, @lowest_offer_listing.seller_feedback_count
  end

  def test_multiple_offers_at_lowest_price
    assert_includes [true, false], @lowest_offer_listing.multiple_offers_at_lowest_price
  end

  def test_qualifiers
    assert_kind_of MWS::Products::Parsers::Qualifiers, @lowest_offer_listing.qualifiers
    assert @lowest_offer_listing.qualifiers.document
  end

  def test_price
    assert_kind_of MWS::Products::Parsers::Price, @lowest_offer_listing.price
    assert @lowest_offer_listing.price.document
  end
end
