# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # The Selling Partner API for Amazon Warehousing and Distribution
    #
    # The Selling Partner API for Amazon Warehousing and Distribution (AWD) provides programmatic access to information
    # about AWD shipments and inventory.
    class AmazonWarehousingAndDistribution20240509 < API
      # Retrieves an AWD inbound shipment.
      #
      # @param [String] shipment_id ID for the shipment. A shipment contains the cases being inbounded.
      # @param [String] sku_quantities If equal to `SHOW`, the response includes the shipment SKU quantity details.
      #   Defaults to `HIDE`, in which case the response does not contain SKU quantities
      # @return [Hash] The API response
      def get_inbound_shipment(shipment_id, sku_quantities: nil)
        path = "/awd/2024-05-09/inboundShipments/#{shipment_id}"
        params = {
          "skuQuantities" => sku_quantities,
        }.compact

        rate_limit(0.5).get(path, params:)
      end

      # Retrieves a summary of all the inbound AWD shipments associated with a merchant, with the ability to apply
      # optional filters.
      #
      # @param [String] sort_by Field to sort results by. By default, the response will be sorted by UPDATED_AT.
      # @param [String] sort_order Sort the response in ASCENDING or DESCENDING order. By default, the response will be
      #   sorted in DESCENDING order.
      # @param [String] shipment_status Filter by inbound shipment status.
      # @param [String] updated_after List the inbound shipments that were updated after a certain time (inclusive). The
      #   date must be in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
      # @param [String] updated_before List the inbound shipments that were updated before a certain time (inclusive).
      #   The date must be in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
      # @param [Integer] max_results Maximum number of results to return.
      # @param [String] next_token Token to retrieve the next set of paginated results.
      # @return [Hash] The API response
      def list_inbound_shipments(sort_by: nil, sort_order: nil, shipment_status: nil, updated_after: nil,
        updated_before: nil, max_results: nil, next_token: nil)
        path = "/awd/2024-05-09/inboundShipments"
        params = {
          "sortBy" => sort_by,
          "sortOrder" => sort_order,
          "shipmentStatus" => shipment_status,
          "updatedAfter" => updated_after,
          "updatedBefore" => updated_before,
          "maxResults" => max_results,
          "nextToken" => next_token,
        }.compact

        rate_limit(1.0).get(path, params:)
      end

      # Lists AWD inventory associated with a merchant with the ability to apply optional filters.
      #
      # @param [String] sku Filter by seller or merchant SKU for the item.
      # @param [String] sort_order Sort the response in `ASCENDING` or `DESCENDING` order.
      # @param [String] details Set to `SHOW` to return summaries with additional inventory details. Defaults to `HIDE,`
      #   which returns only inventory summary totals.
      # @param [String] next_token Token to retrieve the next set of paginated results.
      # @param [Integer] max_results Maximum number of results to return.
      # @return [Hash] The API response
      def list_inventory(sku: nil, sort_order: nil, details: nil, next_token: nil, max_results: nil)
        path = "/awd/2024-05-09/inventory"
        params = {
          "sku" => sku,
          "sortOrder" => sort_order,
          "details" => details,
          "nextToken" => next_token,
          "maxResults" => max_results,
        }.compact

        rate_limit(0.5).get(path, params:)
      end
    end
  end
end
