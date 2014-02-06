require 'integration_helper'
require 'mws/products'

class ProductsTest < IntegrationTest
  self.api = MWS::Products

  def test_gets_lowest_offer_listings_for_sku
    VCR.use_cassette('products/gets_lowest_offer_listings_for_sku') do
      @clients.each do |client|
        res = client.get_lowest_offer_listings_for_sku('123')
        assert_kind_of MWS::Products::Parsers::OfferListingsForSKU, res
      end
    end
  end

  def test_gets_lowest_offer_listings_for_asin
    VCR.use_cassette('products/gets_lowest_offer_listings_for_asin') do
      @clients.each do |client|
        res = client.get_lowest_offer_listings_for_asin('1780935374')
        assert_kind_of MWS::Products::Parsers::OfferListingsForASIN, res
      end
    end
  end
end
