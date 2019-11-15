# frozen_string_literal: true

require 'integration_helper'
require 'mws/shipment_invoicing'

class TestShipmentInvoicing < IntegrationTest
  def test_getting_fba_outbound_shipment_detail
    clients.each do |client|
      if client.marketplace.country_code == 'BR'
        res = client.get_fba_outbound_shipment_detail('A2Q3Y263D00KWC', '456')
        refute_empty res.parse
      else
        assert_raises Peddler::Errors::Error do
          client.get_fba_outbound_shipment_detail('A2Q3Y263D00KWC', '456')
        end
      end
    end
  end

  def test_getting_service_status
    clients.each do |client|
      res = client.get_service_status
      refute_empty res.parse
    end
  end
end
