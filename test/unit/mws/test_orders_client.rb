require 'helper'
require 'mws/orders/client'

class TestMWSOrdersClient < MiniTest::Test
  def setup
    @client = MWS::Orders::Client.new
  end

  def test_lists_orders
    operation = {
      'Action' => 'ListOrders',
      'OrderStatus.Status.1' => '1',
      'MarketplaceId.Id.1' => '1',
      'PaymentMethod.1' => '1',
      'TFMShipmentStatus.Status.1' => '1',
      'FulfillmentChannel.Channel.1' => 'MFN'
    }

    @client.stub(:run, nil) do
      @client.list_orders(
        marketplace_id: '1',
        order_status: '1',
        tfm_shipment_status: '1',
        payment_method: '1',
        fulfillment_channel: 'MFN'
      )
    end

    assert_equal operation, @client.operation
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
