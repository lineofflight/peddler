require 'integration_test_helper'
require 'mws/sellers'

class TestSellers < IntegrationTest
  def test_gets_service_status
    clients.each do |client|
      res = client.get_service_status
      refute_empty res.parse
    end
  end

  def test_get_auth_token
    clients.each do |client|
      res = client.get_auth_token
      refute_empty res.parse
    end
  end
end
