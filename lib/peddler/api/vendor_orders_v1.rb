# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Retail Procurement Orders
    #
    # The Selling Partner API for Retail Procurement Orders provides programmatic access to vendor orders data.
    class VendorOrdersV1 < API
      # Returns a list of purchase orders created or changed during the time frame that you specify. You define the time
      # frame using the `createdAfter`, `createdBefore`, `changedAfter` and `changedBefore` parameters. The date range
      # to search must not be more than 7 days. You can choose to get only the purchase order numbers by setting
      # `includeDetails` to false. You can then use the `getPurchaseOrder` operation to receive details for a specific
      # purchase order.
      #
      # @param [Integer] limit The limit to the number of records returned. Default value is 100 records.
      # @param [String] created_after Purchase orders that became available after this time will be included in the
      #   result. Must be in ISO-8601 date/time format.
      # @param [String] created_before Purchase orders that became available before this time will be included in the
      #   result. Must be in ISO-8601 date/time format.
      # @param [String] sort_order Sort in ascending or descending order by purchase order creation date.
      # @param [String] next_token Used for pagination when there is more purchase orders than the specified result size
      #   limit. The token value is returned in the previous API call
      # @param [String] include_details When true, returns purchase orders with complete details. Otherwise, only
      #   purchase order numbers are returned. Default value is true.
      # @param [String] changed_after Purchase orders that changed after this timestamp will be included in the result.
      #   Must be in ISO-8601 date/time format.
      # @param [String] changed_before Purchase orders that changed before this timestamp will be included in the
      #   result. Must be in ISO-8601 date/time format.
      # @param [String] po_item_state Current state of the purchase order item. If this value is Cancelled, this API
      #   will return purchase orders which have one or more items cancelled by Amazon with updated item quantity as
      #   zero.
      # @param [String] is_po_changed When true, returns purchase orders which were modified after the order was placed.
      #   Vendors are required to pull the changed purchase order and fulfill the updated purchase order and not the
      #   original one. Default value is false.
      # @param [String] purchase_order_state Filters purchase orders based on the purchase order state.
      # @param [String] ordering_vendor_code Filters purchase orders based on the specified ordering vendor code. This
      #   value should be same as 'sellingParty.partyId' in the purchase order. If not included in the filter, all
      #   purchase orders for all of the vendor codes that exist in the vendor group used to authorize the API client
      #   application are returned.
      # @return [Hash] The API response
      def get_purchase_orders(
        limit: nil, created_after: nil, created_before: nil, sort_order: nil, next_token: nil, include_details: nil,
        changed_after: nil, changed_before: nil, po_item_state: nil, is_po_changed: nil, purchase_order_state: nil,
        ordering_vendor_code: nil
      )
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

        rate_limit(10.0).get(path, params:)
      end

      # Returns a purchase order based on the `purchaseOrderNumber` value that you specify.
      #
      # @param [String] purchase_order_number The purchase order identifier for the order that you want. Formatting
      #   Notes: 8-character alpha-numeric code.
      # @return [Hash] The API response
      def get_purchase_order(purchase_order_number)
        path = "/vendor/orders/v1/purchaseOrders/#{purchase_order_number}"

        rate_limit(10.0).get(path)
      end

      # Submits acknowledgements for one or more purchase orders.
      #
      # @param [Hash] body
      # @return [Hash] The API response
      def submit_acknowledgement(body)
        path = "/vendor/orders/v1/acknowledgements"

        rate_limit(10.0).post(path, body:)
      end

      # Returns purchase order statuses based on the filters that you specify. Date range to search must not be more
      # than 7 days. You can return a list of purchase order statuses using the available filters, or a single purchase
      # order status by providing the purchase order number.
      #
      # @param [Integer] limit The limit to the number of records returned. Default value is 100 records.
      # @param [String] sort_order Sort in ascending or descending order by purchase order creation date.
      # @param [String] next_token Used for pagination when there are more purchase orders than the specified result
      #   size limit.
      # @param [String] created_after Purchase orders that became available after this timestamp will be included in the
      #   result. Must be in ISO-8601 date/time format.
      # @param [String] created_before Purchase orders that became available before this timestamp will be included in
      #   the result. Must be in ISO-8601 date/time format.
      # @param [String] updated_after Purchase orders for which the last purchase order update happened after this
      #   timestamp will be included in the result. Must be in ISO-8601 date/time format.
      # @param [String] updated_before Purchase orders for which the last purchase order update happened before this
      #   timestamp will be included in the result. Must be in ISO-8601 date/time format.
      # @param [String] purchase_order_number Provides purchase order status for the specified purchase order number.
      # @param [String] purchase_order_status Filters purchase orders based on the specified purchase order status. If
      #   not included in filter, this will return purchase orders for all statuses.
      # @param [String] item_confirmation_status Filters purchase orders based on their item confirmation status. If the
      #   item confirmation status is not included in the filter, purchase orders for all confirmation statuses are
      #   included.
      # @param [String] item_receive_status Filters purchase orders based on the purchase order's item receive status.
      #   If the item receive status is not included in the filter, purchase orders for all receive statuses are
      #   included.
      # @param [String] ordering_vendor_code Filters purchase orders based on the specified ordering vendor code. This
      #   value should be same as 'sellingParty.partyId' in the purchase order. If not included in filter, all purchase
      #   orders for all the vendor codes that exist in the vendor group used to authorize API client application are
      #   returned.
      # @param [String] ship_to_party_id Filters purchase orders for a specific buyer's Fulfillment Center/warehouse by
      #   providing ship to location id here. This value should be same as 'shipToParty.partyId' in the purchase order.
      #   If not included in filter, this will return purchase orders for all the buyer's warehouses used for vendor
      #   group purchase orders.
      # @return [Hash] The API response
      def get_purchase_orders_status(
        limit: nil, sort_order: nil, next_token: nil, created_after: nil, created_before: nil, updated_after: nil,
        updated_before: nil, purchase_order_number: nil, purchase_order_status: nil, item_confirmation_status: nil,
        item_receive_status: nil, ordering_vendor_code: nil, ship_to_party_id: nil
      )
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

        rate_limit(10.0).get(path, params:)
      end
    end
  end
end
