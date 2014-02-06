require 'request_helper'
require 'mws/products/requests/offer_listings_for_asin'

class MWSProductsOfferListingsForASINRequestTest < RequestTest
  def mock_response_body
    <<-EOF
      <Response xmlns="ns">
        <Result>
          <OfferListings>
          </OfferListings>
        </Result>
      </Response>
    EOF
  end

  def setup
    @offer_listings = MWS::Products::Requests::OfferListingsForASIN.new(mock_client)
  end

  def test_gets_lowest_offer_listings_for_asin
    res = @offer_listings.get_lowest('123')
    assert_kind_of MWS::Products::Parsers::OfferListingsForASIN, res
  end
end
