# frozen_string_literal: true

require 'integration_helper'
require 'mws/merchant_fulfillment'

class TestMerchantFulfillment < IntegrationTest
  def test_getting_eligible_shipments_in_the_us
    client = clients.us
    res = client.get_eligible_shipping_services(shipment_request_details)
    refute res.dig('ShippingServiceList', 'ShippingService').count.zero?
  end

  def test_shipping_in_the_us
    client = clients.us
    res = client.create_shipment(shipment_request_details, 'UPS_PTP_GND')
    label = res.dig('Shipment', 'Label')
    data_compressed = Base64.decode64(label['FileContents']['Contents'])
    data = Zlib.gunzip(data_compressed)
    assert_equal label['FileContents']['Checksum'], Digest::MD5.base64digest(data)
    res = client.cancel_shipment(res.dig('Shipment', 'ShipmentId'))
    assert_equal 'RefundPending', res.dig('Shipment', 'Status')
  end

  def test_getting_service_status
    clients.each do |client|
      res = client.get_service_status
      refute_empty res.parse
    end
  end

  private

  def shipment_request_details
    {
      amazon_order_id: '123-1234567-1234567',
      item_list: [
        {
          order_item_id: '12345678901234',
          quantity: 1
        }
      ],
      ship_from_address: {
        name: 'John Doe',
        address_line_1: '10 Jay St',
        email: 'john@example.com',
        city: 'Brooklyn',
        state_or_province_code: 'NY',
        postal_code: '11201',
        country_code: 'US',
        phone: '7181231234'
      },
      package_dimensions: {
        length: 40,
        width: 30,
        height: 10,
        unit: 'centimeters'
      },
      weight: {
        value: 1000,
        unit: 'grams'
      },
      shipping_service_options: {
        carrier_will_pick_up: false,
        delivery_experience: 'DeliveryConfirmationWithoutSignature'
      }
    }
  end
end
