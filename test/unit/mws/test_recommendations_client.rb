require 'helper'
require 'mws/recommendations/client'

class TestMWSRecommendationsClient < MiniTest::Test
  def setup
    @client = MWS::Recommendations::Client.new
  end

  def test_gets_last_updated_time_for_recommendations
    operation = {
      'Action' => 'GetLastUpdatedTimeForRecommendations',
      'MarketplaceId' => '1'
    }

    @client.stub(:run, nil) do
      @client.get_last_updated_time_for_recommendations('1')
    end

    assert_equal operation, @client.operation
  end

  def test_lists_recommendations
    operation = {
      'Action' => 'ListRecommendations',
      'CategoryQueryList.CategoryQuery.1.FilterOptions.FilterOption.1.Foo' => '1',
      'MarketplaceId' => '123'
    }

    @client.primary_marketplace_id = '123'
    @client.stub(:run, nil) do
      @client.list_recommendations(category_query_list: [{ 'Foo' => '1' }])
    end

    assert_equal operation, @client.operation
  end

  def test_lists_recommendations_by_next_token
    operation = {
      'Action' => 'ListRecommendationsByNextToken',
      'NextToken' => '1'
    }

    @client.stub(:run, nil) do
      @client.list_recommendations_by_next_token('1')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_service_status
    operation = {
      'Action' => 'GetServiceStatus'
    }

    @client.stub(:run, nil) do
      @client.get_service_status
    end

    assert_equal operation, @client.operation
  end
end
