require 'integration_helper'
require 'mws/sellers'

class SellersTest < IntegrationTest
  def test_lists_marketplace_participations
    clients.each do |client|
      res = client.list_marketplace_participations
      refute_empty res.parse
    end
  end

  def test_gets_service_status
    clients.each do |client|
      res = client.get_service_status
      refute_empty res.parse
    end
  end
end
