require 'helper'
require 'mws/webstore'

class TestWebstore < IntegrationTest
  def test_lists_subscriptions_counts
    clients.each do |client|
      res = client.list_subscriptions_count('Subscribed')
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
