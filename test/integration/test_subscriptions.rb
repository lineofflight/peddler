require 'integration_helper'
require 'mws/subscriptions'

class SubscriptionsTest < IntegrationTest
  self.api = MWS::Subscriptions

  def test_manages_destinations
    VCR.use_cassette('subscriptions/manages_destinations') do
      queue = 'https://foo/123/bar'
      @clients.each do |client|
        client.register_destination(queue)
        client.send_test_notification_to_destination(queue)
        client.deregister_destination(queue)
      end
    end
  end

  def test_lists_registered_destinations
    VCR.use_cassette('subscriptions/lists_registered_destinations') do
      @clients.each do |client|
        res = client.list_registered_destinations
        assert_kind_of Integer, res.count
      end
    end
  end

  def test_gets_service_status
    VCR.use_cassette('subscriptions/gets_service_status') do
      @clients.each do |client|
        assert client.get_service_status
      end
    end
  end
end
