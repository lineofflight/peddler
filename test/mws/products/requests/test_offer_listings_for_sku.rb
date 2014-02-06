require 'request_helper'
require 'mws/products/requests/offer_listings_for_sku'

class MWSProductsOfferListingsForSKURequestTest < RequestTest
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
    @offer_listings = MWS::Products::Requests::OfferListingsForSKU.new(mock_client)
  end

  def test_gets_lowest_offer_listings_for_sku
    res = @offer_listings.get_lowest('123')
    assert_kind_of MWS::Products::Parsers::OfferListingsForSKU, res
  end
end
