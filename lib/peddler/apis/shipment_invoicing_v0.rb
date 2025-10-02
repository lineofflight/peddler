# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/api"

module Peddler
  class << self
    def shipment_invoicing_v0
      api = APIs::ShipmentInvoicingV0
      typed? ? api.typed : api
    end
  end

  module APIs
    # Selling Partner API for Shipment Invoicing
    #
    # The Selling Partner API for Shipment Invoicing helps you programmatically retrieve shipment invoice information in
    # the Brazil marketplace for a selling partner’s Fulfillment by Amazon (FBA) orders.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/shipment-invoicing-api-model/shipmentInvoicingV0.json
    class ShipmentInvoicingV0 < API
      # Returns the shipment details required to issue an invoice for the specified shipment.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] The identifier for the shipment. Get this value from the FBAOutboundShipmentStatus
      #   notification. For information about subscribing to notifications, see the
      #   {https://developer-docs.amazon.com/sp-api/docs/notifications-api-v1-use-case-guide Notifications API Use Case
      #   Guide}.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_shipment_details(shipment_id, rate_limit: 1.133)
        path = "/fba/outbound/brazil/v0/shipments/#{percent_encode(shipment_id)}"
        parser = Peddler::Types::ShipmentInvoicingV0::GetShipmentDetailsResponse if typed?
        meter(rate_limit).get(path, parser:)
      end

      # Submits a shipment invoice document for a given shipment.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] The identifier for the shipment.
      # @param body [Hash]
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def submit_invoice(shipment_id, body, rate_limit: 1.133)
        path = "/fba/outbound/brazil/v0/shipments/#{percent_encode(shipment_id)}/invoice"
        parser = Peddler::Types::ShipmentInvoicingV0::SubmitInvoiceResponse if typed?
        meter(rate_limit).post(path, body:, parser:)
      end

      # Returns the invoice status for the shipment you specify.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] The shipment identifier for the shipment.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_invoice_status(shipment_id, rate_limit: 1.133)
        path = "/fba/outbound/brazil/v0/shipments/#{percent_encode(shipment_id)}/invoice/status"
        parser = Peddler::Types::ShipmentInvoicingV0::GetInvoiceStatusResponse if typed?
        meter(rate_limit).get(path, parser:)
      end
    end
  end
end
