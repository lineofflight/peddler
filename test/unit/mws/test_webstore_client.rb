require 'helper'
require 'mws/webstore/client'

class TestMWSWebstoreClient < MiniTest::Test
  def setup
    @client = MWS::Webstore::Client.new
  end

  def test_lists_subscriptions_count
    @client.primary_marketplace_id = '123'
    operation = {
      'Action' => 'ListSubscriptionsCount',
      'MarketplaceId' => '123',
      'SubscriptionState' => '1',
      'SellerSKUList.SellerSKU.1' => '1'
    }

    @client.stub(:run, nil) do
      @client.list_subscriptions_count('1', seller_sku_list: ['1'])
    end

    assert_equal operation, @client.operation
  end

  def test_lists_subscriptions_count_with_alternate_marketplace
    operation = {
      'Action' => 'ListSubscriptionsCount',
      'MarketplaceId' => '321',
      'SubscriptionState' => '1',
      'SellerSKUList.SellerSKU.1' => '1'
    }

    @client.stub(:run, nil) do
      @client.list_subscriptions_count(
        '1',
        seller_sku_list: ['1'],
        marketplace_id: '321'
      )
    end

    assert_equal operation, @client.operation
  end

  def test_lists_subscriptions_count_by_next_token
    operation = {
      'Action' => 'ListSubscriptionsCountByNextToken',
      'NextToken' => '1'
    }

    @client.stub(:run, nil) do
      @client.list_subscriptions_count_by_next_token('1')
    end

    assert_equal operation, @client.operation
  end

  def test_get_subscriptions_details
    @client.primary_marketplace_id = '123'
    operation = {
      'Action' => 'GetSubscriptionDetails',
      'MarketplaceId' => '123',
      'SellerSKU' => '1',
      'SubscriptionState' => '2',
      'DateRangeStart' => '3'
    }

    @client.stub(:run, nil) do
      @client.get_subscription_details('1', '2', '3')
    end

    assert_equal operation, @client.operation
  end

  def test_get_subscriptions_details_with_alternate_marketplace
    operation = {
      'Action' => 'GetSubscriptionDetails',
      'MarketplaceId' => '321',
      'SellerSKU' => '1',
      'SubscriptionState' => '2',
      'DateRangeStart' => '3'
    }

    @client.stub(:run, nil) do
      @client.get_subscription_details('1', '2', '3', marketplace_id: '321')
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
