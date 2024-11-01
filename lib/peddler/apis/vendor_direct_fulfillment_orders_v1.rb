# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def vendor_direct_fulfillment_orders_v1(...)
      APIs::VendorDirectFulfillmentOrdersV1.new(...)
    end
  end

  module APIs
    # Selling Partner API for Direct Fulfillment Orders
    #
    # The Selling Partner API for Direct Fulfillment Orders provides programmatic access to a direct fulfillment
    # vendor's order data.
    class VendorDirectFulfillmentOrdersV1 < API
      # Returns a list of purchase orders created during the time frame that you specify. You define the time frame
      # using the createdAfter and createdBefore parameters. You must use both parameters. You can choose to get only
      # the purchase order numbers by setting the includeDetails parameter to false. In that case, the operation returns
      # a list of purchase order numbers. You can then call the getOrder operation to return the details of a specific
      # order.
      #
      # @note This operation can make a static sandbox call.
      # @param ship_from_party_id [String] The vendor warehouse identifier for the fulfillment warehouse. If not
      #   specified, the result will contain orders for all warehouses.
      # @param status [String] Returns only the purchase orders that match the specified status. If not specified, the
      #   result will contain orders that match any status.
      # @param limit [Integer] The limit to the number of purchase orders returned.
      # @param created_after [String] Purchase orders that became available after this date and time will be included in
      #   the result. Must be in ISO-8601 date/time format.
      # @param created_before [String] Purchase orders that became available before this date and time will be included
      #   in the result. Must be in ISO-8601 date/time format.
      # @param sort_order [String] Sort the list in ascending or descending order by order creation date.
      # @param next_token [String] Used for pagination when there are more orders than the specified result size limit.
      #   The token value is returned in the previous API call.
      # @param include_details [String] When true, returns the complete purchase order details. Otherwise, only purchase
      #   order numbers are returned.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_orders(created_after, created_before, ship_from_party_id: nil, status: nil, limit: nil, sort_order: nil,
        next_token: nil, include_details: "true", rate_limit: 10.0)
        path = "/vendor/directFulfillment/orders/v1/purchaseOrders"
        params = {
          "shipFromPartyId" => ship_from_party_id,
          "status" => status,
          "limit" => limit,
          "createdAfter" => created_after,
          "createdBefore" => created_before,
          "sortOrder" => sort_order,
          "nextToken" => next_token,
          "includeDetails" => include_details,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Returns purchase order information for the purchaseOrderNumber that you specify.
      #
      # @note This operation can make a static sandbox call.
      # @param purchase_order_number [String] The order identifier for the purchase order that you want. Formatting
      #   Notes: alpha-numeric code.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_order(purchase_order_number, rate_limit: 10.0)
        path = "/vendor/directFulfillment/orders/v1/purchaseOrders/#{purchase_order_number}"

        meter(rate_limit).get(path)
      end

      # Submits acknowledgements for one or more purchase orders.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The request body that contains the order acknowledgement.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def submit_acknowledgement(body, rate_limit: 10.0)
        path = "/vendor/directFulfillment/orders/v1/acknowledgements"

        meter(rate_limit).post(path, body:)
      end
    end
  end
end
