require 'helper'
require 'mws/subscriptions/client'

class TestMWSSubscriptionsClient < MiniTest::Test
  def setup
    @client = MWS::Subscriptions::Client.new

  def test_updates_subscription
    operation = {
      'Action' => 'UpdateSubscription',
      'MarketplaceId' => '123',
      'Subscription.IsEnabled' => true,
      'Subscription.NotificationType' => 'foo',
      'Subscription.Destination.DeliveryChannel' => 'SQS',
      'Subscription.Destination.AttributeList.member.1.Key' => 'sqsQueueUrl',
      'Subscription.Destination.AttributeList.member.1.Value' => 'bar'
    }

    @client.stub(:run, nil) do
      @client.update_subscription('foo', 'bar', true)
    end

    assert_equal operation, @client.operation
  end

  def test_updates_subscription_with_alternate_marketplace
    operation = {
      'Action' => 'UpdateSubscription',
      'MarketplaceId' => '321',
      'Subscription.IsEnabled' => true,
      'Subscription.NotificationType' => 'foo',
      'Subscription.Destination.DeliveryChannel' => 'SQS',
      'Subscription.Destination.AttributeList.member.1.Key' => 'sqsQueueUrl',
      'Subscription.Destination.AttributeList.member.1.Value' => 'bar'
    }

    @client.stub(:run, nil) do
      @client.update_subscription('foo', 'bar', true, '321')
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

  # FIXME Fill in tests for operations
end
