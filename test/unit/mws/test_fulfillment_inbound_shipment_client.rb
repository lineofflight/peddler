require 'helper'
require 'mws/fulfillment_inbound_shipment/client'

class TestMWSFulfillmentInboundShipmentClient < MiniTest::Test
  def setup
    @client = MWS::FulfillmentInboundShipment::Client.new
  end

  def test_creates_inbound_shipment_plan
    operation = {
      'Action' => 'CreateInboundShipmentPlan',
      'ShipFromAddress.Foo' => '1',
      'InboundShipmentPlanRequestItems.member.1.Bar' => '2'
    }

    @client.stub(:run, nil) do
      @client.create_inbound_shipment_plan({ 'Foo' => '1' }, [{ 'Bar' => '2' }])
    end

    assert_equal operation, @client.operation
  end

  def test_creates_inbound_shipment
    operation = {
      'Action' => 'CreateInboundShipment',
      'ShipmentId' => '1',
      'InboundShipmentHeader.Foo' => '1',
      'InboundShipmentItems.member.1.Bar' => '2'
    }

    @client.stub(:run, nil) do
      @client.create_inbound_shipment('1', { 'Foo' => '1' }, inbound_shipment_items: [{ 'Bar' => '2' }])
    end

    assert_equal operation, @client.operation
  end

  def test_updates_inbound_shipment
    operation = {
      'Action' => 'UpdateInboundShipment',
      'ShipmentId' => '1',
      'InboundShipmentHeader.Foo' => '1',
      'InboundShipmentItems.member.1.Bar' => '2'
    }

    @client.stub(:run, nil) do
      @client.update_inbound_shipment('1', { 'Foo' => '1' }, inbound_shipment_items: [{ 'Bar' => '2' }])
    end

    assert_equal operation, @client.operation
  end

  def test_puts_transport_content
    transport_details = {
      'ParcelData' => {
        'PackageList' => [
          {
            'TrackingId' => '123'
          }
        ]
      }
    }

    operation = {
      'Action' => 'PutTransportContent',
      'ShipmentId' => '1',
      'IsPartnered' => true,
      'ShipmentType' => 'Foo',
      'TransportDetails.ParcelData.PackageList.member.1.TrackingId' => '123'
    }

    @client.stub(:run, nil) do
      @client.put_transport_content('1', true, 'Foo', transport_details)
    end

    assert_equal operation, @client.operation
  end

  def test_estimates_transport_request
    operation = {
      'Action' => 'EstimateTransportRequest',
      'ShipmentId' => '1'
    }

    @client.stub(:run, nil) do
      @client.estimate_transport_request('1')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_transport_request
    operation = {
      'Action' => 'GetTransportContent',
      'ShipmentId' => '1'
    }

    @client.stub(:run, nil) do
      @client.get_transport_content('1')
    end

    assert_equal operation, @client.operation
  end

  def test_confirms_transport_request
    operation = {
      'Action' => 'ConfirmTransportRequest',
      'ShipmentId' => '1'
    }

    @client.stub(:run, nil) do
      @client.confirm_transport_request('1')
    end

    assert_equal operation, @client.operation
  end

  def test_voids_transport_request
    operation = {
      'Action' => 'VoidTransportRequest',
      'ShipmentId' => '1'
    }

    @client.stub(:run, nil) do
      @client.void_transport_request('1')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_package_labels
    operation = {
      'Action' => 'GetPackageLabels',
      'ShipmentId' => '1',
      'PageType' => '2'
    }

    @client.stub(:run, nil) do
      @client.get_package_labels('1', '2')
    end

    assert_equal operation, @client.operation
  end

  def test_gets_bill_of_lading
    operation = {
      'Action' => 'GetBillOfLading',
      'ShipmentId' => '1'
    }

    @client.stub(:run, nil) do
      @client.get_bill_of_lading('1')
    end

    assert_equal operation, @client.operation
  end

  def test_lists_inbound_shipments
    operation = {
      'Action' => 'ListInboundShipments',
      'ShipmentStatusList.member.1' => 'Foo',
      'ShipmentIdList.member.1' => 'Bar'
    }

    @client.stub(:run, nil) do
      @client.list_inbound_shipments(
        shipment_status_list: ['Foo'],
        shipment_id_list: ['Bar'])
    end

    assert_equal operation, @client.operation
  end

  def test_lists_inbound_shipments_by_next_token
    operation = {
      'Action' => 'ListInboundShipmentsByNextToken',
      'NextToken' => '1'
    }

    @client.stub(:run, nil) do
      @client.list_inbound_shipments_by_next_token('1')
    end

    assert_equal operation, @client.operation
  end

  def test_lists_inbound_shipment_items
    operation = {
      'Action' => 'ListInboundShipmentItems'
    }

    @client.stub(:run, nil) do
      @client.list_inbound_shipment_items
    end

    assert_equal operation, @client.operation
  end

  def test_lists_inbound_shipment_items_by_next_token
    operation = {
      'Action' => 'ListInboundShipmentItemsByNextToken',
      'NextToken' => '1'
    }

    @client.stub(:run, nil) do
      @client.list_inbound_shipment_items_by_next_token('1')
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
