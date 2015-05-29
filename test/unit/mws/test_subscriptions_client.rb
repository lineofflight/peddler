require 'helper'
require 'mws/subscriptions/client'

class TestMWSSubscriptionsClient < MiniTest::Test
  def setup
    @client = MWS::Subscriptions::Client.new
    @client.primary_marketplace_id = '123'
  end

  def test_registers_destination
    operation = {
      'Action' => 'RegisterDestination',
      'MarketplaceId' => '123',
      'Destination.DeliveryChannel' => 'SQS',
      'Destination.AttributeList.member.1.Key' => 'sqsQueueUrl',
      'Destination.AttributeList.member.1.Value' => 'foo'
    }

    @client.stub(:run, nil) do
      @client.register_destination('foo')
    end

    assert_equal operation, @client.operation
  end

  def test_registers_destination_with_alternate_marketplace
    operation = {
      'Action' => 'RegisterDestination',
      'MarketplaceId' => '321',
      'Destination.DeliveryChannel' => 'SQS',
      'Destination.AttributeList.member.1.Key' => 'sqsQueueUrl',
      'Destination.AttributeList.member.1.Value' => 'foo'
    }

    @client.stub(:run, nil) do
      @client.register_destination('foo', '321')
    end

    assert_equal operation, @client.operation
  end

  def test_deregisters_destination
    operation = {
      'Action' => 'DeregisterDestination',
      'MarketplaceId' => '123',
      'Destination.DeliveryChannel' => 'SQS',
      'Destination.AttributeList.member.1.Key' => 'sqsQueueUrl',
      'Destination.AttributeList.member.1.Value' => 'foo'
    }

    @client.stub(:run, nil) do
      @client.deregister_destination('foo')
    end

    assert_equal operation, @client.operation
  end

  def test_deregisters_destination_with_alternate_marketplace
    operation = {
      'Action' => 'DeregisterDestination',
      'MarketplaceId' => '321',
      'Destination.DeliveryChannel' => 'SQS',
      'Destination.AttributeList.member.1.Key' => 'sqsQueueUrl',
      'Destination.AttributeList.member.1.Value' => 'foo'
    }

    @client.stub(:run, nil) do
      @client.deregister_destination('foo', '321')
    end

    assert_equal operation, @client.operation
  end

  def test_lists_registered_destinations
    operation = {
      'Action' => 'ListRegisteredDestinations',
      'MarketplaceId' => '123'
    }

    @client.stub(:run, nil) do
      @client.list_registered_destinations
    end

    assert_equal operation, @client.operation
  end

  def test_lists_registered_destinations_with_alternate_marketplace
    operation = {
      'Action' => 'ListRegisteredDestinations',
      'MarketplaceId' => '321'
    }

    @client.stub(:run, nil) do
      @client.list_registered_destinations('321')
    end

    assert_equal operation, @client.operation
  end

  def test_sends_test_notification_to_destination
    operation = {
      'Action' => 'SendTestNotificationToDestination',
      'MarketplaceId' => '123',
      'Destination.DeliveryChannel' => 'SQS',
      'Destination.AttributeList.member.1.Key' => 'sqsQueueUrl',
      'Destination.AttributeList.member.1.Value' => 'foo'
    }

    @client.stub(:run, nil) do
      @client.send_test_notification_to_destination('foo')
    end

    assert_equal operation, @client.operation
  end

  def test_send_test_notification_to_destination_with_alternate_marketplace
    operation = {
      'Action' => 'SendTestNotificationToDestination',
      'MarketplaceId' => '321',
      'Destination.DeliveryChannel' => 'SQS',
      'Destination.AttributeList.member.1.Key' => 'sqsQueueUrl',
      'Destination.AttributeList.member.1.Value' => 'foo'
    }

    @client.stub(:run, nil) do
      @client.send_test_notification_to_destination('foo', '321')
    end

    assert_equal operation, @client.operation
  end

  def test_creates_subscription
    operation = {
      'Action' => 'CreateSubscription',
      'MarketplaceId' => '123',
      'Subscription.IsEnabled' => true,
      'Subscription.NotificationType' => 'foo',
      'Subscription.Destination.DeliveryChannel' => 'SQS',
      'Subscription.Destination.AttributeList.member.1.Key' => 'sqsQueueUrl',
      'Subscription.Destination.AttributeList.member.1.Value' => 'bar'
    }

    @client.stub(:run, nil) do
      @client.create_subscription('foo', 'bar')
    end

    assert_equal operation, @client.operation
  end

  def test_creates_subscription_with_alternate_marketplace
    operation = {
      'Action' => 'CreateSubscription',
      'MarketplaceId' => '321',
      'Subscription.IsEnabled' => true,
      'Subscription.NotificationType' => 'foo',
      'Subscription.Destination.DeliveryChannel' => 'SQS',
      'Subscription.Destination.AttributeList.member.1.Key' => 'sqsQueueUrl',
      'Subscription.Destination.AttributeList.member.1.Value' => 'bar'
    }

    @client.stub(:run, nil) do
      @client.create_subscription('foo', 'bar', '321')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_subscription
    operation = {
      'Action' => 'GetSubscription',
      'MarketplaceId' => '123',
      'NotificationType' => 'foo',
      'Destination.DeliveryChannel' => 'SQS',
      'Destination.AttributeList.member.1.Key' => 'sqsQueueUrl',
      'Destination.AttributeList.member.1.Value' => 'bar'
    }

    @client.stub(:run, nil) do
      @client.get_subscription('foo', 'bar')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_subscription_with_alternate_marketplace
    operation = {
      'Action' => 'GetSubscription',
      'MarketplaceId' => '321',
      'NotificationType' => 'foo',
      'Destination.DeliveryChannel' => 'SQS',
      'Destination.AttributeList.member.1.Key' => 'sqsQueueUrl',
      'Destination.AttributeList.member.1.Value' => 'bar'
    }

    @client.stub(:run, nil) do
      @client.get_subscription('foo', 'bar', '321')
    end

    assert_equal operation, @client.operation
  end

  def test_deletes_subscription
    operation = {
      'Action' => 'DeleteSubscription',
      'MarketplaceId' => '123',
      'NotificationType' => 'foo',
      'Destination.DeliveryChannel' => 'SQS',
      'Destination.AttributeList.member.1.Key' => 'sqsQueueUrl',
      'Destination.AttributeList.member.1.Value' => 'bar'
    }

    @client.stub(:run, nil) do
      @client.delete_subscription('foo', 'bar')
    end

    assert_equal operation, @client.operation
  end

  def test_deletes_subscription_with_alternate_marketplace
    operation = {
      'Action' => 'DeleteSubscription',
      'MarketplaceId' => '321',
      'NotificationType' => 'foo',
      'Destination.DeliveryChannel' => 'SQS',
      'Destination.AttributeList.member.1.Key' => 'sqsQueueUrl',
      'Destination.AttributeList.member.1.Value' => 'bar'
    }

    @client.stub(:run, nil) do
      @client.delete_subscription('foo', 'bar', '321')
    end

    assert_equal operation, @client.operation
  end

  def test_lists_subscriptions
    operation = {
      'Action' => 'ListSubscriptions',
      'MarketplaceId' => '123'
    }

    @client.stub(:run, nil) do
      @client.list_subscriptions
    end

    assert_equal operation, @client.operation
  end

  def test_lists_subscriptions_with_alternate_marketplace
    operation = {
      'Action' => 'ListSubscriptions',
      'MarketplaceId' => '321'
    }

    @client.stub(:run, nil) do
      @client.list_subscriptions('321')
    end

    assert_equal operation, @client.operation
  end

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
end
