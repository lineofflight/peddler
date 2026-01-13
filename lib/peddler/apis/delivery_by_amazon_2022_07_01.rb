# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Delivery Shipment Invoicing
    #
    # The Selling Partner API for Delivery Shipment Invoicing helps you programmatically retrieve shipment invoice
    # information in the Brazil marketplace for a selling partner’s orders.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/delivery-by-amazon/deliveryShipmentInvoiceV2022-07-01.json
    class DeliveryByAmazon20220701 < API
      # Submits a shipment invoice for a given order or shipment. You must specify either an `orderId` or `shipmentId`
      # as query parameter. If both parameters are supplied, `orderId` takes precedence over `shipmentId`.
      #
      # @note This operation can make a static sandbox call.
      # @param order_id [String] The identifier for the order.
      # @param shipment_id [String] The identifier for the shipment.
      # @param body [Hash] The request body that specifies invoice, program and marketplace values.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def submit_invoice(body, order_id: nil, shipment_id: nil, rate_limit: 1.133)
        path = "/delivery/2022-07-01/invoice"
        params = {
          "orderId" => order_id,
          "shipmentId" => shipment_id,
        }.compact
        parser = -> { SubmitInvoiceResponse }
        post(path, body:, params:, rate_limit:, parser:)
      end

      # Returns the invoice status for the order or shipment you specify. You must specify either an `orderId` or
      # `shipmentId` as query parameter. If both parameters are supplied, `orderId` takes precedence over `shipmentId`.
      #
      # @note This operation can make a static sandbox call.
      # @param order_id [String] The order identifier.
      # @param shipment_id [String] The shipment identifier.
      # @param marketplace_id [String] The marketplace identifier.
      # @param invoice_type [String] The invoice's type.
      # @param program_type [String] The Amazon program that seller is currently enrolled.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_invoice_status(marketplace_id, invoice_type, program_type, order_id: nil, shipment_id: nil,
        rate_limit: 1.133)
        path = "/delivery/2022-07-01/invoice/status"
        params = {
          "orderId" => order_id,
          "shipmentId" => shipment_id,
          "marketplaceId" => marketplace_id,
          "invoiceType" => invoice_type,
          "programType" => program_type,
        }.compact
        parser = -> { GetInvoiceStatusResponse }
        get(path, params:, rate_limit:, parser:)
      end
    end
  end
end
