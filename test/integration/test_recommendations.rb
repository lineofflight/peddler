require 'helper'
require 'mws/recommendations'

class TestRecommendations < IntegrationTest
  def test_lists_recommendations
    clients.each do |client|
      res = client.list_recommendations
      content = res.parse
      skip unless content
      refute_empty content
    end
  end

  def test_gets_service_status
    clients.each do |client|
      res = client.get_service_status
      refute_empty res.parse
    end
  end
end
