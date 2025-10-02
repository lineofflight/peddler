# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/api"

module Peddler
  class << self
    def vendor_orders_v1
      typed? ? APIs::VendorOrdersV1.typed : APIs::VendorOrdersV1
    end
  end

  module APIs
    # Selling Partner API for Retail Procurement Orders
    #
    # The Selling Partner API for Retail Procurement Orders provides programmatic access to vendor orders data.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/vendor-orders-api-model/vendorOrders.json
    class VendorOrdersV1 < API
      class << self
        # Enables typed response parsing
        # @return [self]
        def typed
          @typed = true
          require_relative "../types/vendor_orders_v1"
          self
        end
      end

      # Returns a list of purchase orders created or changed during the time frame that you specify. You define the time
      # frame using the `createdAfter`, `createdBefore`, `changedAfter` and `changedBefore` parameters. The date range
      # to search must not be more than 7 days. You can choose to get only the purchase order numbers by setting
      # `includeDetails` to false. You can then use the `getPurchaseOrder` operation to receive details for a specific
      # purchase order.
      #
      # @note This operation can make a static sandbox call.
      # @param limit [Integer] The limit to the number of records returned. Default value is 100 records.
      # @param created_after [String] Purchase orders that became available after this time will be included in the
      #   result. Must be in ISO-8601 date/time format.
      # @param created_before [String] Purchase orders that became available before this time will be included in the
      #   result. Must be in ISO-8601 date/time format.
      # @param sort_order [String] Sort in ascending or descending order by purchase order creation date.
      # @param next_token [String] Used for pagination when there is more purchase orders than the specified result size
      #   limit. The token value is returned in the previous API call
      # @param include_details [String] When true, returns purchase orders with complete details. Otherwise, only
      #   purchase order numbers are returned. Default value is true.
      # @param changed_after [String] Purchase orders that changed after this timestamp will be included in the result.
      #   Must be in ISO-8601 date/time format.
      # @param changed_before [String] Purchase orders that changed before this timestamp will be included in the
      #   result. Must be in ISO-8601 date/time format.
      # @param po_item_state [String] Current state of the purchase order item. If this value is Cancelled, this API
      #   will return purchase orders which have one or more items cancelled by Amazon with updated item quantity as
      #   zero.
      # @param is_po_changed [String] When true, returns purchase orders which were modified after the order was placed.
      #   Vendors are required to pull the changed purchase order and fulfill the updated purchase order and not the
      #   original one. Default value is false.
      # @param purchase_order_state [String] Filters purchase orders based on the purchase order state.
      # @param ordering_vendor_code [String] Filters purchase orders based on the specified ordering vendor code. This
      #   value should be same as 'sellingParty.partyId' in the purchase order. If not included in the filter, all
      #   purchase orders for all of the vendor codes that exist in the vendor group used to authorize the API client
      #   application are returned.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_purchase_orders(limit: nil, created_after: nil, created_before: nil, sort_order: nil, next_token: nil,
        include_details: nil, changed_after: nil, changed_before: nil, po_item_state: nil, is_po_changed: nil,
        purchase_order_state: nil, ordering_vendor_code: nil, rate_limit: 10.0)
        path = "/vendor/orders/v1/purchaseOrders"
        params = {
          "limit" => limit,
          "createdAfter" => created_after,
          "createdBefore" => created_before,
          "sortOrder" => sort_order,
          "nextToken" => next_token,
          "includeDetails" => include_details,
          "changedAfter" => changed_after,
          "changedBefore" => changed_before,
          "poItemState" => po_item_state,
          "isPOChanged" => is_po_changed,
          "purchaseOrderState" => purchase_order_state,
          "orderingVendorCode" => ordering_vendor_code,
        }.compact
        parser = Peddler::Types::VendorOrdersV1::GetPurchaseOrdersResponse if typed?
        meter(rate_limit).get(path, params:, parser:)
      end

      # Returns a purchase order based on the `purchaseOrderNumber` value that you specify.
      #
      # @note This operation can make a static sandbox call.
      # @param purchase_order_number [String] The purchase order identifier for the order that you want. Formatting
      #   Notes: 8-character alpha-numeric code.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_purchase_order(purchase_order_number, rate_limit: 10.0)
        path = "/vendor/orders/v1/purchaseOrders/#{percent_encode(purchase_order_number)}"
        parser = Peddler::Types::VendorOrdersV1::GetPurchaseOrderResponse if typed?
        meter(rate_limit).get(path, parser:)
      end

      # Submits acknowledgements for one or more purchase orders.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] Submits acknowledgements for one or more purchase orders from a vendor.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def submit_acknowledgement(body, rate_limit: 10.0)
        path = "/vendor/orders/v1/acknowledgements"
        parser = Peddler::Types::VendorOrdersV1::SubmitAcknowledgementResponse if typed?
        meter(rate_limit).post(path, body:, parser:)
      end

      # Returns purchase order statuses based on the filters that you specify. Date range to search must not be more
      # than 7 days. You can return a list of purchase order statuses using the available filters, or a single purchase
      # order status by providing the purchase order number.
      #
      # @note This operation can make a static sandbox call.
      # @param limit [Integer] The limit to the number of records returned. Default value is 100 records.
      # @param sort_order [String] Sort in ascending or descending order by purchase order creation date.
      # @param next_token [String] Used for pagination when there are more purchase orders than the specified result
      #   size limit.
      # @param created_after [String] Purchase orders that became available after this timestamp will be included in the
      #   result. Must be in ISO-8601 date/time format.
      # @param created_before [String] Purchase orders that became available before this timestamp will be included in
      #   the result. Must be in ISO-8601 date/time format.
      # @param updated_after [String] Purchase orders for which the last purchase order update happened after this
      #   timestamp will be included in the result. Must be in ISO-8601 date/time format.
      # @param updated_before [String] Purchase orders for which the last purchase order update happened before this
      #   timestamp will be included in the result. Must be in ISO-8601 date/time format.
      # @param purchase_order_number [String] Provides purchase order status for the specified purchase order number.
      # @param purchase_order_status [String] Filters purchase orders based on the specified purchase order status. If
      #   not included in filter, this will return purchase orders for all statuses.
      # @param item_confirmation_status [String] Filters purchase orders based on their item confirmation status. If the
      #   item confirmation status is not included in the filter, purchase orders for all confirmation statuses are
      #   included.
      # @param item_receive_status [String] Filters purchase orders based on the purchase order's item receive status.
      #   If the item receive status is not included in the filter, purchase orders for all receive statuses are
      #   included.
      # @param ordering_vendor_code [String] Filters purchase orders based on the specified ordering vendor code. This
      #   value should be same as 'sellingParty.partyId' in the purchase order. If not included in filter, all purchase
      #   orders for all the vendor codes that exist in the vendor group used to authorize API client application are
      #   returned.
      # @param ship_to_party_id [String] Filters purchase orders for a specific buyer's Fulfillment Center/warehouse by
      #   providing ship to location id here. This value should be same as 'shipToParty.partyId' in the purchase order.
      #   If not included in filter, this will return purchase orders for all the buyer's warehouses used for vendor
      #   group purchase orders.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_purchase_orders_status(limit: nil, sort_order: nil, next_token: nil, created_after: nil,
        created_before: nil, updated_after: nil, updated_before: nil, purchase_order_number: nil,
        purchase_order_status: nil, item_confirmation_status: nil, item_receive_status: nil, ordering_vendor_code: nil,
        ship_to_party_id: nil, rate_limit: 10.0)
        path = "/vendor/orders/v1/purchaseOrdersStatus"
        params = {
          "limit" => limit,
          "sortOrder" => sort_order,
          "nextToken" => next_token,
          "createdAfter" => created_after,
          "createdBefore" => created_before,
          "updatedAfter" => updated_after,
          "updatedBefore" => updated_before,
          "purchaseOrderNumber" => purchase_order_number,
          "purchaseOrderStatus" => purchase_order_status,
          "itemConfirmationStatus" => item_confirmation_status,
          "itemReceiveStatus" => item_receive_status,
          "orderingVendorCode" => ordering_vendor_code,
          "shipToPartyId" => ship_to_party_id,
        }.compact
        parser = Peddler::Types::VendorOrdersV1::GetPurchaseOrdersStatusResponse if typed?
        meter(rate_limit).get(path, params:, parser:)
      end
    end
  end
end
