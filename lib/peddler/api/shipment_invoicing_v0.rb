# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Shipment Invoicing
    #
    # The Selling Partner API for Shipment Invoicing helps you programmatically retrieve shipment invoice information in
    # the Brazil marketplace for a selling partner’s Fulfillment by Amazon (FBA) orders.
    class ShipmentInvoicingV0 < API
      # Returns the shipment details required to issue an invoice for the specified shipment.
      #
      # @param [String] shipment_id The identifier for the shipment. Get this value from the FBAOutboundShipmentStatus
      #   notification. For information about subscribing to notifications, see the [Notifications API Use Case
      #   Guide](doc:notifications-api-v1-use-case-guide).
      # @return [Hash] The API response
      def get_shipment_details(shipment_id)
        path = "/fba/outbound/brazil/v0/shipments/#{shipment_id}"

        rate_limit(1.133).get(path)
      end

      # Submits a shipment invoice document for a given shipment.
      #
      # @param [String] shipment_id The identifier for the shipment.
      # @param [Hash] body
      # @return [Hash] The API response
      def submit_invoice(shipment_id, body)
        path = "/fba/outbound/brazil/v0/shipments/#{shipment_id}/invoice"
        body = body

        rate_limit(1.133).post(path, body:)
      end

      # Returns the invoice status for the shipment you specify.
      #
      # @param [String] shipment_id The shipment identifier for the shipment.
      # @return [Hash] The API response
      def get_invoice_status(shipment_id)
        path = "/fba/outbound/brazil/v0/shipments/#{shipment_id}/invoice/status"

        rate_limit(1.133).get(path)
      end
    end
  end
end
