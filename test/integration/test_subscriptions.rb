require 'integration_helper'
require 'mws/subscriptions'

class SubscriptionsTest < IntegrationTest
  self.api = MWS::Subscriptions

  def test_gets_service_status
    VCR.use_cassette('subscriptions/gets_service_status') do
      @clients.each do |client|
        assert client.get_service_status
      end
    end
  end
end
