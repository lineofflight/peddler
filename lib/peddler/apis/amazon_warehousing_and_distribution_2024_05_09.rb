# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def amazon_warehousing_and_distribution_2024_05_09(...)
      APIs::AmazonWarehousingAndDistribution20240509.new(...)
    end
  end

  module APIs
    # The Selling Partner API for Amazon Warehousing and Distribution
    #
    # The Selling Partner API for Amazon Warehousing and Distribution (AWD) provides programmatic access to information
    # about AWD shipments and inventory.
    class AmazonWarehousingAndDistribution20240509 < API
      # Retrieves an AWD inbound shipment.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] ID for the shipment. A shipment contains the cases being inbounded.
      # @param sku_quantities [String] If equal to `SHOW`, the response includes the shipment SKU quantity details.
      #   Defaults to `HIDE`, in which case the response does not contain SKU quantities
      # @param rate_limit [Float] Requests per second
      # @param tries [Integer] Total request attempts, including retries
      # @return [Peddler::Response] The API response
      def get_inbound_shipment(shipment_id, sku_quantities: nil, rate_limit: 2.0, tries: 2)
        path = "/awd/2024-05-09/inboundShipments/#{shipment_id}"
        params = {
          "skuQuantities" => sku_quantities,
        }.compact

        meter(rate_limit, tries:).get(path, params:)
      end

      # Retrieves a summary of all the inbound AWD shipments associated with a merchant, with the ability to apply
      # optional filters.
      #
      # @note This operation can make a static sandbox call.
      # @param sort_by [String] Field to sort results by. By default, the response will be sorted by UPDATED_AT.
      # @param sort_order [String] Sort the response in ASCENDING or DESCENDING order. By default, the response will be
      #   sorted in DESCENDING order.
      # @param shipment_status [String] Filter by inbound shipment status.
      # @param updated_after [String] List the inbound shipments that were updated after a certain time (inclusive). The
      #   date must be in {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
      # @param updated_before [String] List the inbound shipments that were updated before a certain time (inclusive).
      #   The date must be in {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
      # @param max_results [Integer] Maximum number of results to return.
      # @param next_token [String] Token to retrieve the next set of paginated results.
      # @param rate_limit [Float] Requests per second
      # @param tries [Integer] Total request attempts, including retries
      # @return [Peddler::Response] The API response
      def list_inbound_shipments(sort_by: nil, sort_order: nil, shipment_status: nil, updated_after: nil,
        updated_before: nil, max_results: 25, next_token: nil, rate_limit: 1.0, tries: 2)
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

        meter(rate_limit, tries:).get(path, params:)
      end

      # Lists AWD inventory associated with a merchant with the ability to apply optional filters.
      #
      # @note This operation can make a static sandbox call.
      # @param sku [String] Filter by seller or merchant SKU for the item.
      # @param sort_order [String] Sort the response in `ASCENDING` or `DESCENDING` order.
      # @param details [String] Set to `SHOW` to return summaries with additional inventory details. Defaults to `HIDE,`
      #   which returns only inventory summary totals.
      # @param next_token [String] Token to retrieve the next set of paginated results.
      # @param max_results [Integer] Maximum number of results to return.
      # @param rate_limit [Float] Requests per second
      # @param tries [Integer] Total request attempts, including retries
      # @return [Peddler::Response] The API response
      def list_inventory(sku: nil, sort_order: nil, details: nil, next_token: nil, max_results: 25, rate_limit: 2.0,
        tries: 2)
        path = "/awd/2024-05-09/inventory"
        params = {
          "sku" => sku,
          "sortOrder" => sort_order,
          "details" => details,
          "nextToken" => next_token,
          "maxResults" => max_results,
        }.compact

        meter(rate_limit, tries:).get(path, params:)
      end
    end
  end
end
