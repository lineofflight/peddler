require 'integration_helper'
require 'mws/products'

class OfferListingsTest < IntegrationTest
  self.api = MWS::Products

  def test_get_lowest_for_sku
    VCR.use_cassette('offer_listings_test/test_get_lower_for_sku') do
      @clients.each do |client|
        res = client.get_lowest_offer_listings_for_sku(seller_sku_list: %w(1A-092S-KNJX JE-SQGJ-SMBV RZ-H2GC-6MT9 TC-0CM4-T9UZ))

      end
    end
  end

end
