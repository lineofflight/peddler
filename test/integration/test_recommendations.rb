# frozen_string_literal: true

require 'integration_helper'
require 'mws/recommendations'

class TestRecommendations < IntegrationTest
  def test_getting_service_status
    clients.each do |client|
      res = client.get_service_status
      refute_empty res.parse
    end
  end
end
