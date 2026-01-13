# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Direct Fulfillment Shipping
    #
    # The Selling Partner API for Direct Fulfillment Shipping provides programmatic access to a direct fulfillment
    # vendor's shipping data.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/vendor-direct-fulfillment-shipping-api-model/vendorDirectFulfillmentShippingV1.json
    class VendorDirectFulfillmentShippingV1 < API
      # Returns a list of shipping labels created during the time frame that you specify. You define that time frame
      # using the createdAfter and createdBefore parameters. You must use both of these parameters. The date range to
      # search must not be more than 7 days.
      #
      # @note This operation can make a static sandbox call.
      # @param ship_from_party_id [String] The vendor warehouseId for order fulfillment. If not specified, the result
      #   will contain orders for all warehouses.
      # @param limit [Integer] The limit to the number of records returned.
      # @param created_after [String] Shipping labels that became available after this date and time will be included in
      #   the result. Must be in ISO-8601 date/time format.
      # @param created_before [String] Shipping labels that became available before this date and time will be included
      #   in the result. Must be in ISO-8601 date/time format.
      # @param sort_order [String] Sort ASC or DESC by order creation date.
      # @param next_token [String] Used for pagination when there are more ship labels than the specified result size
      #   limit. The token value is returned in the previous API call.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_shipping_labels(created_after, created_before, ship_from_party_id: nil, limit: nil, sort_order: "ASC",
        next_token: nil, rate_limit: 10.0)
        path = "/vendor/directFulfillment/shipping/v1/shippingLabels"
        params = {
          "shipFromPartyId" => ship_from_party_id,
          "limit" => limit,
          "createdAfter" => created_after,
          "createdBefore" => created_before,
          "sortOrder" => sort_order,
          "nextToken" => next_token,
        }.compact
        parser = -> { GetShippingLabelListResponse }
        get(path, params:, rate_limit:, parser:)
      end

      # Creates a shipping label for a purchase order and returns a transactionId for reference.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] Request body containing one or more shipping labels data.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def submit_shipping_label_request(body, rate_limit: 10.0)
        path = "/vendor/directFulfillment/shipping/v1/shippingLabels"
        parser = -> { SubmitShippingLabelsResponse }
        post(path, body:, rate_limit:, parser:)
      end

      # Returns a shipping label for the purchaseOrderNumber that you specify.
      #
      # @note This operation can make a static sandbox call.
      # @param purchase_order_number [String] The purchase order number for which you want to return the shipping label.
      #   It should be the same purchaseOrderNumber as received in the order.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_shipping_label(purchase_order_number, rate_limit: 10.0)
        path = "/vendor/directFulfillment/shipping/v1/shippingLabels/#{percent_encode(purchase_order_number)}"
        parser = -> { GetShippingLabelResponse }
        get(path, rate_limit:, parser:)
      end

      # Submits one or more shipment confirmations for vendor orders.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] Request body containing the shipment confirmations data.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def submit_shipment_confirmations(body, rate_limit: 10.0)
        path = "/vendor/directFulfillment/shipping/v1/shipmentConfirmations"
        parser = -> { SubmitShipmentConfirmationsResponse }
        post(path, body:, rate_limit:, parser:)
      end

      # This API call is only to be used by Vendor-Own-Carrier (VOC) vendors. Calling this API will submit a shipment
      # status update for the package that a vendor has shipped. It will provide the Amazon customer visibility on their
      # order, when the package is outside of Amazon Network visibility.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] Request body containing the shipment status update data.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def submit_shipment_status_updates(body, rate_limit: 10.0)
        path = "/vendor/directFulfillment/shipping/v1/shipmentStatusUpdates"
        parser = -> { SubmitShipmentStatusUpdatesResponse }
        post(path, body:, rate_limit:, parser:)
      end

      # Returns a list of customer invoices created during a time frame that you specify. You define the time frame
      # using the createdAfter and createdBefore parameters. You must use both of these parameters. The date range to
      # search must be no more than 7 days.
      #
      # @note This operation can make a static sandbox call.
      # @param ship_from_party_id [String] The vendor warehouseId for order fulfillment. If not specified, the result
      #   will contain orders for all warehouses.
      # @param limit [Integer] The limit to the number of records returned
      # @param created_after [String] Orders that became available after this date and time will be included in the
      #   result. Must be in ISO-8601 date/time format.
      # @param created_before [String] Orders that became available before this date and time will be included in the
      #   result. Must be in ISO-8601 date/time format.
      # @param sort_order [String] Sort ASC or DESC by order creation date.
      # @param next_token [String] Used for pagination when there are more orders than the specified result size limit.
      #   The token value is returned in the previous API call.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_customer_invoices(created_after, created_before, ship_from_party_id: nil, limit: nil, sort_order: nil,
        next_token: nil, rate_limit: 10.0)
        path = "/vendor/directFulfillment/shipping/v1/customerInvoices"
        params = {
          "shipFromPartyId" => ship_from_party_id,
          "limit" => limit,
          "createdAfter" => created_after,
          "createdBefore" => created_before,
          "sortOrder" => sort_order,
          "nextToken" => next_token,
        }.compact
        parser = -> { GetCustomerInvoicesResponse }
        get(path, params:, rate_limit:, parser:)
      end

      # Returns a customer invoice based on the purchaseOrderNumber that you specify.
      #
      # @note This operation can make a static sandbox call.
      # @param purchase_order_number [String] Purchase order number of the shipment for which to return the invoice.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_customer_invoice(purchase_order_number, rate_limit: 10.0)
        path = "/vendor/directFulfillment/shipping/v1/customerInvoices/#{percent_encode(purchase_order_number)}"
        parser = -> { GetCustomerInvoiceResponse }
        get(path, rate_limit:, parser:)
      end

      # Returns a list of packing slips for the purchase orders that match the criteria specified. Date range to search
      # must not be more than 7 days.
      #
      # @note This operation can make a static sandbox call.
      # @param ship_from_party_id [String] The vendor warehouseId for order fulfillment. If not specified the result
      #   will contain orders for all warehouses.
      # @param limit [Integer] The limit to the number of records returned
      # @param created_after [String] Packing slips that became available after this date and time will be included in
      #   the result. Must be in ISO-8601 date/time format.
      # @param created_before [String] Packing slips that became available before this date and time will be included in
      #   the result. Must be in ISO-8601 date/time format.
      # @param sort_order [String] Sort ASC or DESC by packing slip creation date.
      # @param next_token [String] Used for pagination when there are more packing slips than the specified result size
      #   limit. The token value is returned in the previous API call.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_packing_slips(created_after, created_before, ship_from_party_id: nil, limit: nil, sort_order: "ASC",
        next_token: nil, rate_limit: 10.0)
        path = "/vendor/directFulfillment/shipping/v1/packingSlips"
        params = {
          "shipFromPartyId" => ship_from_party_id,
          "limit" => limit,
          "createdAfter" => created_after,
          "createdBefore" => created_before,
          "sortOrder" => sort_order,
          "nextToken" => next_token,
        }.compact
        parser = -> { GetPackingSlipListResponse }
        get(path, params:, rate_limit:, parser:)
      end

      # Returns a packing slip based on the purchaseOrderNumber that you specify.
      #
      # @note This operation can make a static sandbox call.
      # @param purchase_order_number [String] The purchaseOrderNumber for the packing slip you want.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_packing_slip(purchase_order_number, rate_limit: 10.0)
        path = "/vendor/directFulfillment/shipping/v1/packingSlips/#{percent_encode(purchase_order_number)}"
        parser = -> { GetPackingSlipResponse }
        get(path, rate_limit:, parser:)
      end
    end
  end
end
