# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/api"

module Peddler
  class << self
    def amazon_warehousing_and_distribution_2024_05_09
      APIs::AmazonWarehousingAndDistribution20240509
    end
  end

  module APIs
    # The Selling Partner API for Amazon Warehousing and Distribution
    #
    # The Selling Partner API for Amazon Warehousing and Distribution (AWD) provides programmatic access to information
    # about AWD shipments and inventory.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/amazon-warehousing-and-distribution-model/awd_2024-05-09.json
    class AmazonWarehousingAndDistribution20240509 < API
      # Creates a draft AWD inbound order with a list of packages for inbound shipment. The operation creates one
      # shipment per order.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] Payload for creating an inbound order.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_inbound(body, rate_limit: 1.0)
        path = "/awd/2024-05-09/inboundOrders"
        parser = Peddler::Types::AmazonWarehousingAndDistribution20240509::InboundOrderReference if typed?
        meter(rate_limit).post(path, body:, parser:)
      end

      # Retrieves an AWD inbound order.
      #
      # @note This operation can make a static sandbox call.
      # @param order_id [String] The ID of the inbound order that you want to retrieve.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_inbound(order_id, rate_limit: 2.0)
        path = "/awd/2024-05-09/inboundOrders/#{percent_encode(order_id)}"
        parser = Peddler::Types::AmazonWarehousingAndDistribution20240509::InboundOrder if typed?
        meter(rate_limit).get(path, parser:)
      end

      # Updates an AWD inbound order that is in `DRAFT` status and not yet confirmed. Use this operation to update the
      # `packagesToInbound`, `originAddress` and `preferences` attributes.
      #
      # @note This operation can make a static sandbox call.
      # @param order_id [String] The ID of the inbound order that you want to update.
      # @param body [Hash] Represents an AWD inbound order.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def update_inbound(order_id, body, rate_limit: 1.0)
        path = "/awd/2024-05-09/inboundOrders/#{percent_encode(order_id)}"
        meter(rate_limit).put(path, body:)
      end

      # Cancels an AWD Inbound order and its associated shipment.
      #
      # @note This operation can make a static sandbox call.
      # @param order_id [String] The ID of the inbound order you want to cancel.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def cancel_inbound(order_id, rate_limit: 1.0)
        path = "/awd/2024-05-09/inboundOrders/#{percent_encode(order_id)}/cancellation"
        meter(rate_limit).post(path)
      end

      # Confirms an AWD inbound order in `DRAFT` status.
      #
      # @note This operation can make a static sandbox call.
      # @param order_id [String] The ID of the inbound order that you want to confirm.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def confirm_inbound(order_id, rate_limit: 1.0)
        path = "/awd/2024-05-09/inboundOrders/#{percent_encode(order_id)}/confirmation"
        meter(rate_limit).post(path)
      end

      # Retrieves an AWD inbound shipment.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] ID for the shipment. A shipment contains the cases being inbounded.
      # @param sku_quantities [String] If equal to `SHOW`, the response includes the shipment SKU quantity details.
      #   Defaults to `HIDE`, in which case the response does not contain SKU quantities
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_inbound_shipment(shipment_id, sku_quantities: nil, rate_limit: 2.0)
        path = "/awd/2024-05-09/inboundShipments/#{percent_encode(shipment_id)}"
        params = {
          "skuQuantities" => sku_quantities,
        }.compact
        parser = Peddler::Types::AmazonWarehousingAndDistribution20240509::InboundShipment if typed?
        meter(rate_limit).get(path, params:, parser:)
      end

      # Retrieves the box labels for a shipment ID that you specify. This is an asynchronous operation. If the label
      # status is `GENERATED`, then the label URL is available.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] ID for the shipment.
      # @param page_type [String] Page type for the generated labels. The default is `PLAIN_PAPER`.
      # @param format_type [String] The format type of the output file that contains your labels. The default format
      #   type is `PDF`.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_inbound_shipment_labels(shipment_id, page_type: nil, format_type: nil, rate_limit: 1.0)
        path = "/awd/2024-05-09/inboundShipments/#{percent_encode(shipment_id)}/labels"
        params = {
          "pageType" => page_type,
          "formatType" => format_type,
        }.compact
        parser = Peddler::Types::AmazonWarehousingAndDistribution20240509::ShipmentLabels if typed?
        meter(rate_limit).get(path, params:, parser:)
      end

      # Updates transport details for an AWD shipment.
      #
      # @note This operation can make a static sandbox call.
      # @param shipment_id [String] The shipment ID.
      # @param body [Hash] Transportation details for the shipment.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def update_inbound_shipment_transport_details(shipment_id, body, rate_limit: 1.0)
        path = "/awd/2024-05-09/inboundShipments/#{percent_encode(shipment_id)}/transport"
        meter(rate_limit).put(path, body:)
      end

      # Determines if the packages you specify are eligible for an AWD inbound order and contains error details for
      # ineligible packages.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] Represents the packages you want to inbound.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def check_inbound_eligibility(body, rate_limit: 1.0)
        path = "/awd/2024-05-09/inboundEligibility"
        parser = Peddler::Types::AmazonWarehousingAndDistribution20240509::InboundEligibility if typed?
        meter(rate_limit).post(path, body:, parser:)
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
      # @param next_token [String] A token that is used to retrieve the next page of results. The response includes
      #   `nextToken` when the number of results exceeds the specified `maxResults` value. To get the next page of
      #   results, call the operation with this token and include the same arguments as the call that produced the
      #   token. To get a complete list, call this operation until `nextToken` is null. Note that this operation can
      #   return empty pages.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_inbound_shipments(sort_by: nil, sort_order: nil, shipment_status: nil, updated_after: nil,
        updated_before: nil, max_results: 25, next_token: nil, rate_limit: 1.0)
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
        parser = Peddler::Types::AmazonWarehousingAndDistribution20240509::ShipmentListing if typed?
        meter(rate_limit).get(path, params:, parser:)
      end

      # Lists AWD inventory associated with a merchant with the ability to apply optional filters.
      #
      # @note This operation can make a static sandbox call.
      # @param sku [String] Filter by seller or merchant SKU for the item.
      # @param sort_order [String] Sort the response in `ASCENDING` or `DESCENDING` order.
      # @param details [String] Set to `SHOW` to return summaries with additional inventory details. Defaults to `HIDE,`
      #   which returns only inventory summary totals.
      # @param next_token [String] A token that is used to retrieve the next page of results. The response includes
      #   `nextToken` when the number of results exceeds the specified `maxResults` value. To get the next page of
      #   results, call the operation with this token and include the same arguments as the call that produced the
      #   token. To get a complete list, call this operation until `nextToken` is null. Note that this operation can
      #   return empty pages.
      # @param max_results [Integer] Maximum number of results to return.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_inventory(sku: nil, sort_order: nil, details: nil, next_token: nil, max_results: 25, rate_limit: 2.0)
        path = "/awd/2024-05-09/inventory"
        params = {
          "sku" => sku,
          "sortOrder" => sort_order,
          "details" => details,
          "nextToken" => next_token,
          "maxResults" => max_results,
        }.compact
        parser = Peddler::Types::AmazonWarehousingAndDistribution20240509::InventoryListing if typed?
        meter(rate_limit).get(path, params:, parser:)
      end
    end
  end
end
