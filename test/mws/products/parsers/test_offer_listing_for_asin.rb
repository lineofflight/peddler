require 'parser_helper'
require 'mws/products/parsers/offer_listing_for_asin'

class OfferListingForASINParserTest < ParserTest
  def setup
    node = fixture('products/lowest_offer_listings_for_asin').xpath('//xmlns:GetLowestOfferListingsForASINResult')
    @offer_listing = MWS::Products::Parsers::OfferListingForASIN.new(node)
  end

  def test_status
    assert_kind_of String, @offer_listing.status
  end

  def test_asin
    assert_kind_of String, @offer_listing.asin
  end

  def test_product
    assert_kind_of MWS::Products::Parsers::Product, @offer_listing.product
  end

  def test_all_offer_listings_considered
    assert_includes [true, false], @offer_listing.all_offer_listings_considered
  end
end
