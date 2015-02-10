require 'test_helper'
require 'mws/orders/client'

class TestOrdersClient < MiniTest::Test
  def setup
    @client = MWS::Orders::Client.new
  end

  def test_list_orders_has_marketplace_id
    @client.stub(:run, nil) do
      @client.list_orders(marketplace_id: '1')
      @client.operation.key?('MarketplaceId.Id.1')
    end
  end

  def test_list_orders_has_order_status
    @client.stub(:run, nil) do
      @client.list_orders(order_status: '1')
      @client.operation.key?('OrderStatus.Status.1')
    end
  end

  def test_list_orders_has_tfm_shipment_status
    @client.stub(:run, nil) do
      @client.list_orders(tfm_shipment_status: '1')
      @client.operation.key?('TFMShipmentStatus.Status.1')
    end
  end

  def test_list_orders_has_payment_method
    @client.stub(:run, nil) do
      @client.list_orders(payment_method: '1')
      @client.operation.key?('PaymentMethod.1')
    end
  end

  def test_get_order_has_amazon_order_ids
    @client.stub(:run, nil) do
      @client.get_order('1', '2')
      @client.operation.key?('AmazonOrderId.Id.1')
      @client.operation.key?('AmazonOrderId.Id.2')
    end
  end
end
