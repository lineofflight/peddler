require 'integration_helper'
require 'mws/sellers'

class ServiceStatusTest < IntegrationTest
  self.api = MWS::Sellers

  def test_gets_service_status
    @clients.each do |client|
      assert client.get_service_status
    end
  end
end
