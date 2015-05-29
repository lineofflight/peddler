require 'helper'
require 'mws/fulfillment_outbound_shipment/client'

class TestMWSFulfillmentOutboundShipmentClient < MiniTest::Test
  def setup
    @client = MWS::FulfillmentOutboundShipment::Client.new
  end

  def test_gets_fulfillment_preview
    operation = {
      'Action' => 'GetFulfillmentPreview',
      'Address.Foo' => '1',
      'Items.member.1.Bar' => '2',
      'ShippingSpeedCategories.1' => '3',
      'IncludeCODFulfillmentPreview' => true
    }

    @client.stub(:run, nil) do
      @client.get_fulfillment_preview(
        { 'Foo' => '1' },
        [{ 'Bar' => '2' }],
        shipping_speed_categories: ['3'],
        include_cod_fulfillment_preview: true
      )
    end

    assert_equal operation, @client.operation
  end

  def test_creates_fulfillment_order
    operation = {
      'Action' => 'CreateFulfillmentOrder',
      'SellerFulfillmentOrderId' => '1',
      'DisplayableOrderId' => '2',
      'DisplayableOrderDateTime' => '3',
      'DisplayableOrderComment' => '4',
      'ShippingSpeedCategory' => '5',
      'DestinationAddress.Foo' => '1',
      'Items.member.1.Bar' => '2',
      'CODSettings.Foo' => '1',
      'NotificationEmailList.member.1' => '1'
    }

    @client.stub(:run, nil) do
      @client.create_fulfillment_order(
        '1', '2', '3', '4', '5',
        { 'Foo' => '1' },
        [{ 'Bar' => '2' }],
        cod_settings: { 'Foo' => '1' },
        notification_email_list: ['1']
      )
    end

    assert_equal operation, @client.operation
  end

  def test_updates_fulfillment_order
    operation = {
      'Action' => 'UpdateFulfillmentOrder',
      'SellerFulfillmentOrderId' => '1',
      'Items.member.1.Bar' => '2',
      'NotificationEmailList.member.1' => '1'
    }

    @client.stub(:run, nil) do
      @client.update_fulfillment_order(
        '1',
        items: [{ 'Bar' => '2' }],
        notification_email_list: ['1']
      )
    end

    assert_equal operation, @client.operation
  end

  def test_gets_fulfillment_order
    operation = {
      'Action' => 'GetFulfillmentOrder',
      'SellerFulfillmentOrderId' => '1'
    }

    @client.stub(:run, nil) do
      @client.get_fulfillment_order('1')
    end

    assert_equal operation, @client.operation
  end

  def test_lists_all_fulfillment_orders
    operation = {
      'Action' => 'ListAllFulfillmentOrders'
    }

    @client.stub(:run, nil) do
      @client.list_all_fulfillment_orders
    end

    assert_equal operation, @client.operation
  end

  def test_lists_all_fulfillment_orders_by_next_token
    operation = {
      'Action' => 'ListAllFulfillmentOrdersByNextToken',
      'NextToken' => '1'
    }

    @client.stub(:run, nil) do
      @client.list_all_fulfillment_orders_by_next_token('1')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_package_tracking_details
    assert_raises(NotImplementedError) do
      @client.get_package_tracking_details
    end
  end

  def test_cancels_fulfillment_order
    operation = {
      'Action' => 'CancelFulfillmentOrder',
      'SellerFulfillmentOrderId' => '1'
    }

    @client.stub(:run, nil) do
      @client.cancel_fulfillment_order('1')
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
