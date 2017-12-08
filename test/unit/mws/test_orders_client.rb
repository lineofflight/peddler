# frozen_string_literal: true

require 'helper'
require 'mws/orders/client'

class TestMWSOrdersClient < MiniTest::Test
  def setup
    @client = MWS::Orders::Client.new
  end

  def test_lists_orders
    operation = {
      'Action' => 'ListOrders',
      'CreatedAfter' => '2016-01-01',
      'OrderStatus.Status.1' => '1',
      'MarketplaceId.Id.1' => '1',
      'PaymentMethod.1' => '1',
      'TFMShipmentStatus.Status.1' => '1',
      'FulfillmentChannel.Channel.1' => 'MFN'
    }

    @client.stub(:run, nil) do
      @client.list_orders(
        marketplace_id: '1',
        created_after: '2016-01-01',
        order_status: '1',
        tfm_shipment_status: '1',
        payment_method: '1',
        fulfillment_channel: 'MFN'
      )
    end

    assert_equal operation, @client.operation
  end

  def test_requires_start_time_keyword_when_listing_orders
    @client.stub(:run, nil) do
      assert_raises(ArgumentError) do
        @client.list_orders
      end
      @client.list_orders(created_after: '2016-01-01')
      @client.list_orders(last_updated_after: '2016-01-01')
    end
  end

  def test_lists_orders_by_next_token
    operation = {
      'Action' => 'ListOrdersByNextToken',
      'NextToken' => '1'
    }

    @client.stub(:run, nil) do
      @client.list_orders_by_next_token('1')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_order
    operation = {
      'Action' => 'GetOrder',
      'AmazonOrderId.Id.1' => '1',
      'AmazonOrderId.Id.2' => '2'
    }

    @client.stub(:run, nil) do
      @client.get_order('1', '2')
    end

    assert_equal operation, @client.operation
  end

  def test_lists_order_items
    operation = {
      'Action' => 'ListOrderItems',
      'AmazonOrderId' => '1'
    }

    @client.stub(:run, nil) do
      @client.list_order_items('1')
    end

    assert_equal operation, @client.operation
  end

  def test_lists_order_items_by_next_token
    operation = {
      'Action' => 'ListOrderItemsByNextToken',
      'NextToken' => '1'
    }

    @client.stub(:run, nil) do
      @client.list_order_items_by_next_token('1')
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
