require 'integration_helper'
require 'mws/sellers'

class SellersTest < IntegrationTest
  self.api = MWS::Sellers

  def test_lists_marketplace_participations
    VCR.use_cassette('sellers/lists_marketplace_participations') do
      @clients.each do |client|
        mps = client.list_marketplace_participations
        assert_kind_of MWS::Sellers::Parsers::MarketplaceParticipations, mps
      end
    end
  end

  def test_gets_service_status
    VCR.use_cassette('sellers/gets_service_status') do
      @clients.each do |client|
        assert client.get_service_status
      end
    end
  end
end
