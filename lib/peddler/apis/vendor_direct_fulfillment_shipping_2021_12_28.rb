# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/api"

module Peddler
  class << self
    def vendor_direct_fulfillment_shipping_2021_12_28
      APIs::VendorDirectFulfillmentShipping20211228
    end
  end

  module APIs
    # Selling Partner API for Direct Fulfillment Shipping
    #
    # Use the Selling Partner API for Direct Fulfillment Shipping to access a direct fulfillment vendor's shipping data.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/vendor-direct-fulfillment-shipping-api-model/vendorDirectFulfillmentShipping_2021-12-28.json
    class VendorDirectFulfillmentShipping20211228 < API
      # Returns a list of shipping labels created during the time frame that you specify. Use the `createdAfter` and
      # `createdBefore` parameters to define the time frame. You must use both of these parameters. The date range to
      # search must not be more than seven days.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param ship_from_party_id [String] The vendor `warehouseId` for order fulfillment. If not specified, the result
      #   contains orders for all warehouses.
      # @param limit [Integer] The limit to the number of records returned.
      # @param created_after [String] Shipping labels that became available after this date and time will be included in
      #   the result. Values are in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format.
      # @param created_before [String] Shipping labels that became available before this date and time will be included
      #   in the result. Values are in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time
      #   format.
      # @param sort_order [String] The sort order creation date. You can choose between ascending (`ASC`) or descending
      #   (`DESC`) sort order.
      # @param next_token [String] Used for pagination when there are more ship labels than the specified result size
      #   limit. The token value is returned in the previous API call.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_shipping_labels(created_after, created_before, ship_from_party_id: nil, limit: nil, sort_order: "ASC",
        next_token: nil, rate_limit: 10.0)
        path = "/vendor/directFulfillment/shipping/2021-12-28/shippingLabels"
        params = {
          "shipFromPartyId" => ship_from_party_id,
          "limit" => limit,
          "createdAfter" => created_after,
          "createdBefore" => created_before,
          "sortOrder" => sort_order,
          "nextToken" => next_token,
        }.compact
        parser = Peddler::Types::VendorDirectFulfillmentShipping20211228::ShippingLabelList if typed?
        meter(rate_limit).get(path, params:, parser:)
      end

      # Creates a shipping label for a purchase order and returns a `transactionId` for reference.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param body [Hash] The request body that contains the shipping labels data.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def submit_shipping_label_request(body, rate_limit: 10.0)
        path = "/vendor/directFulfillment/shipping/2021-12-28/shippingLabels"
        parser = Peddler::Types::VendorDirectFulfillmentShipping20211228::TransactionReference if typed?
        meter(rate_limit).post(path, body:, parser:)
      end

      # Returns a shipping label for the `purchaseOrderNumber` that you specify.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param purchase_order_number [String] The purchase order number for which you want to return the shipping label.
      #   It should be the same `purchaseOrderNumber` that you received in the order.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_shipping_label(purchase_order_number, rate_limit: 10.0)
        path = "/vendor/directFulfillment/shipping/2021-12-28/shippingLabels/#{percent_encode(purchase_order_number)}"
        parser = Peddler::Types::VendorDirectFulfillmentShipping20211228::ShippingLabel if typed?
        meter(rate_limit).get(path, parser:)
      end

      # Creates shipping labels for a purchase order and returns the labels.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param purchase_order_number [String] The purchase order number for which you want to return the shipping
      #   labels. It should be the same number as the `purchaseOrderNumber` in the order.
      # @param body [Hash] The request payload that contains the parameters for creating shipping labels.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_shipping_labels(purchase_order_number, body, rate_limit: 10.0)
        path = "/vendor/directFulfillment/shipping/2021-12-28/shippingLabels/#{percent_encode(purchase_order_number)}"
        parser = Peddler::Types::VendorDirectFulfillmentShipping20211228::ShippingLabel if typed?
        meter(rate_limit).post(path, body:, parser:)
      end

      # Submits one or more shipment confirmations for vendor orders.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param body [Hash] Request body containing the shipment confirmations data.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def submit_shipment_confirmations(body, rate_limit: 10.0)
        path = "/vendor/directFulfillment/shipping/2021-12-28/shipmentConfirmations"
        parser = Peddler::Types::VendorDirectFulfillmentShipping20211228::TransactionReference if typed?
        meter(rate_limit).post(path, body:, parser:)
      end

      # This operation is only to be used by Vendor-Own-Carrier (VOC) vendors. Calling this API submits a shipment
      # status update for the package that a vendor has shipped. It will provide the Amazon customer visibility on their
      # order, when the package is outside of Amazon Network visibility.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param body [Hash] Request body containing the shipment status update data.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def submit_shipment_status_updates(body, rate_limit: 10.0)
        path = "/vendor/directFulfillment/shipping/2021-12-28/shipmentStatusUpdates"
        parser = Peddler::Types::VendorDirectFulfillmentShipping20211228::TransactionReference if typed?
        meter(rate_limit).post(path, body:, parser:)
      end

      # Returns a list of customer invoices created during a time frame that you specify. You define the time frame
      # using the createdAfter and createdBefore parameters. You must use both of these parameters. The date range to
      # search must be no more than 7 days.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param ship_from_party_id [String] The vendor warehouseId for order fulfillment. If not specified, the result
      #   will contain orders for all warehouses.
      # @param limit [Integer] The limit to the number of records returned
      # @param created_after [String] Orders that became available after this date and time will be included in the
      #   result. Values are in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format.
      # @param created_before [String] Orders that became available before this date and time will be included in the
      #   result. Values are in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format.
      # @param sort_order [String] Sort ASC or DESC by order creation date.
      # @param next_token [String] Used for pagination when there are more orders than the specified result size limit.
      #   The token value is returned in the previous API call.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_customer_invoices(created_after, created_before, ship_from_party_id: nil, limit: nil, sort_order: nil,
        next_token: nil, rate_limit: 10.0)
        path = "/vendor/directFulfillment/shipping/2021-12-28/customerInvoices"
        params = {
          "shipFromPartyId" => ship_from_party_id,
          "limit" => limit,
          "createdAfter" => created_after,
          "createdBefore" => created_before,
          "sortOrder" => sort_order,
          "nextToken" => next_token,
        }.compact
        parser = Peddler::Types::VendorDirectFulfillmentShipping20211228::CustomerInvoiceList if typed?
        meter(rate_limit).get(path, params:, parser:)
      end

      # Returns a customer invoice based on the purchaseOrderNumber that you specify.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param purchase_order_number [String] Purchase order number of the shipment for which to return the invoice.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_customer_invoice(purchase_order_number, rate_limit: 10.0)
        path = "/vendor/directFulfillment/shipping/2021-12-28/customerInvoices/#{percent_encode(purchase_order_number)}"
        parser = Peddler::Types::VendorDirectFulfillmentShipping20211228::CustomerInvoice if typed?
        meter(rate_limit).get(path, parser:)
      end

      # Returns a list of packing slips for the purchase orders that match the criteria specified. Date range to search
      # must not be more than 7 days.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param ship_from_party_id [String] The vendor `warehouseId` for order fulfillment. If not specified, the result
      #   contains orders for all warehouses.
      # @param limit [Integer] The maximum number of records to return.
      # @param created_after [String] Packing slips that become available after this date and time will be included in
      #   the result. Values are in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format.
      # @param created_before [String] Packing slips that became available before this date and time will be included in
      #   the result. Values are in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format.
      # @param sort_order [String] The packing slip creation dates, which are sorted by ascending or descending order.
      # @param next_token [String] Used for pagination when there are more packing slips than the specified result size
      #   limit. The token value is returned in the previous API call.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_packing_slips(created_after, created_before, ship_from_party_id: nil, limit: nil, sort_order: "ASC",
        next_token: nil, rate_limit: 10.0)
        path = "/vendor/directFulfillment/shipping/2021-12-28/packingSlips"
        params = {
          "shipFromPartyId" => ship_from_party_id,
          "limit" => limit,
          "createdAfter" => created_after,
          "createdBefore" => created_before,
          "sortOrder" => sort_order,
          "nextToken" => next_token,
        }.compact
        parser = Peddler::Types::VendorDirectFulfillmentShipping20211228::PackingSlipList if typed?
        meter(rate_limit).get(path, params:, parser:)
      end

      # Returns a packing slip based on the purchaseOrderNumber that you specify.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param purchase_order_number [String] The `purchaseOrderNumber` for the packing slip that you want.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_packing_slip(purchase_order_number, rate_limit: 10.0)
        path = "/vendor/directFulfillment/shipping/2021-12-28/packingSlips/#{percent_encode(purchase_order_number)}"
        parser = Peddler::Types::VendorDirectFulfillmentShipping20211228::PackingSlip if typed?
        meter(rate_limit).get(path, parser:)
      end

      # Creates a container (pallet) label for the associated shipment package.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param body [Hash] Request body containing the container label data.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_container_label(body, rate_limit: 10.0)
        path = "/vendor/directFulfillment/shipping/2021-12-28/containerLabel"
        parser = Peddler::Types::VendorDirectFulfillmentShipping20211228::CreateContainerLabelResponse if typed?
        meter(rate_limit).post(path, body:, parser:)
      end
    end
  end
end
