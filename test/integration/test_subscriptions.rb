require 'helper'
require 'mws/subscriptions'

class TestSubscriptions < IntegrationTest
  def test_lists_registered_destinations
    clients.each do |client|
      res = client.list_registered_destinations
      refute_empty res.parse
    end
  end

  def test_lists_subscriptions
    clients.each do |client|
      res = client.list_subscriptions
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
