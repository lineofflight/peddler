require 'integration_helper'
require 'mws/orders'

class ServiceStatusTest < IntegrationTest
  self.api = MWS::Orders

  def test_gets_service_status
    @clients.each do |client|
      assert client.get_service_status
    end
  end
end
