# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def shipment_invoicing_v0(...)
      API::ShipmentInvoicingV0.new(...)
    end
  end

  class API
    # Selling Partner API for Shipment Invoicing
    #
    # The Selling Partner API for Shipment Invoicing helps you programmatically retrieve shipment invoice information in
    # the Brazil marketplace for a selling partner’s Fulfillment by Amazon (FBA) orders.
    class ShipmentInvoicingV0 < API
      # Returns the shipment details required to issue an invoice for the specified shipment.
      #
      # @note This operation can make a static sandbox call.
      # @param [String] shipment_id The identifier for the shipment. Get this value from the FBAOutboundShipmentStatus
      #   notification. For information about subscribing to notifications, see the [Notifications API Use Case
      #   Guide](https://developer-docs.amazon.com/sp-api/docs/notifications-api-v1-use-case-guide).
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def get_shipment_details(shipment_id, rate_limit: 1.133)
        path = "/fba/outbound/brazil/v0/shipments/#{shipment_id}"

        meter(rate_limit).get(path)
      end

      # Submits a shipment invoice document for a given shipment.
      #
      # @note This operation can make a static sandbox call.
      # @param [String] shipment_id The identifier for the shipment.
      # @param [Hash] body
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def submit_invoice(shipment_id, body, rate_limit: 1.133)
        path = "/fba/outbound/brazil/v0/shipments/#{shipment_id}/invoice"

        meter(rate_limit).post(path, body:)
      end

      # Returns the invoice status for the shipment you specify.
      #
      # @note This operation can make a static sandbox call.
      # @param [String] shipment_id The shipment identifier for the shipment.
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def get_invoice_status(shipment_id, rate_limit: 1.133)
        path = "/fba/outbound/brazil/v0/shipments/#{shipment_id}/invoice/status"

        meter(rate_limit).get(path)
      end
    end
  end
end
