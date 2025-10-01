# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/api"

module Peddler
  class << self
    def fba_inventory_v1(...)
      APIs::FBAInventoryV1.new(...)
    end
  end

  module APIs
    # Selling Partner API for FBA Inventory
    #
    # The Selling Partner API for FBA Inventory lets you programmatically retrieve information about inventory in
    # Amazon's fulfillment network.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/fba-inventory-api-model/fbaInventory.json
    class FBAInventoryV1 < API
      # Returns a list of inventory summaries. The summaries returned depend on the presence or absence of the
      # startDateTime, sellerSkus and sellerSku parameters:
      #
      # - All inventory summaries with available details are returned when the startDateTime, sellerSkus and sellerSku
      # parameters are omitted.
      # - When startDateTime is provided, the operation returns inventory summaries that have had changes after the date
      # and time specified. The sellerSkus and sellerSku parameters are ignored. Important: To avoid errors, use both
      # startDateTime and nextToken to get the next page of inventory summaries that have changed after the date and
      # time specified.
      # - When the sellerSkus parameter is provided, the operation returns inventory summaries for only the specified
      # sellerSkus. The sellerSku parameter is ignored.
      # - When the sellerSku parameter is provided, the operation returns inventory summaries for only the specified
      # sellerSku.
      #
      # Note: The parameters associated with this operation may contain special characters that must be encoded to
      # successfully call the API. To avoid errors with SKUs when encoding URLs, refer to [URL
      # Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding).
      #
      # @note This operation can make a dynamic sandbox call.
      # @param details [Boolean] true to return inventory summaries with additional summarized inventory details and
      #   quantities. Otherwise, returns inventory summaries only (default value).
      # @param granularity_type [String] The granularity type for the inventory aggregation level.
      # @param granularity_id [String] The granularity ID for the inventory aggregation level.
      # @param start_date_time [String] A start date and time in ISO8601 format. If specified, all inventory summaries
      #   that have changed since then are returned. You must specify a date and time that is no earlier than 18 months
      #   prior to the date and time when you call the API. Note: Changes in inboundWorkingQuantity,
      #   inboundShippedQuantity and inboundReceivingQuantity are not detected.
      # @param seller_skus [Array<String>] A list of seller SKUs for which to return inventory summaries. You may
      #   specify up to 50 SKUs.
      # @param seller_sku [String] A single seller SKU used for querying the specified seller SKU inventory summaries.
      # @param next_token [String] String token returned in the response of your previous request. The string token will
      #   expire 30 seconds after being created.
      # @param marketplace_ids [Array<String>] The marketplace ID for the marketplace for which to return inventory
      #   summaries.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_inventory_summaries(granularity_type, granularity_id, marketplace_ids, details: nil, start_date_time: nil,
        seller_skus: nil, seller_sku: nil, next_token: nil, rate_limit: 2.0)
        path = "/fba/inventory/v1/summaries"
        params = {
          "details" => details,
          "granularityType" => granularity_type,
          "granularityId" => granularity_id,
          "startDateTime" => start_date_time,
          "sellerSkus" => stringify_array(seller_skus),
          "sellerSku" => seller_sku,
          "nextToken" => next_token,
          "marketplaceIds" => stringify_array(marketplace_ids),
        }.compact
        parser = Peddler::Types::FBAInventoryV1::GetInventorySummariesResponse if typed?
        meter(rate_limit).get(path, params:, parser:)
      end

      # Requests that Amazon create product-details in the Sandbox Inventory in the sandbox environment. This is a
      # sandbox-only operation and must be directed to a sandbox endpoint. Refer to [Selling Partner API
      # sandbox](https://developer-docs.amazon.com/sp-api/docs/the-selling-partner-api-sandbox) for more information.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param create_inventory_item_request_body [Hash] CreateInventoryItem Request Body Parameter.
      # @return [Peddler::Response] The API response
      def create_inventory_item(create_inventory_item_request_body)
        must_sandbox!

        path = "/fba/inventory/v1/items"
        body = create_inventory_item_request_body
        parser = Peddler::Types::FBAInventoryV1::CreateInventoryItemResponse if typed?
        post(path, body:, parser:)
      end

      # Requests that Amazon Deletes an item from the Sandbox Inventory in the sandbox environment. This is a
      # sandbox-only operation and must be directed to a sandbox endpoint. Refer to [Selling Partner API
      # sandbox](https://developer-docs.amazon.com/sp-api/docs/the-selling-partner-api-sandbox) for more information.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param seller_sku [String] A single seller SKU used for querying the specified seller SKU inventory summaries.
      # @param marketplace_id [String] The marketplace ID for the marketplace for which the sellerSku is to be deleted.
      # @return [Peddler::Response] The API response
      def delete_inventory_item(seller_sku, marketplace_id)
        must_sandbox!

        path = "/fba/inventory/v1/items/#{percent_encode(seller_sku)}"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact
        parser = Peddler::Types::FBAInventoryV1::DeleteInventoryItemResponse if typed?
        delete(path, params:, parser:)
      end

      # Requests that Amazon add items to the Sandbox Inventory with desired amount of quantity in the sandbox
      # environment. This is a sandbox-only operation and must be directed to a sandbox endpoint. Refer to [Selling
      # Partner API sandbox](https://developer-docs.amazon.com/sp-api/docs/the-selling-partner-api-sandbox) for more
      # information.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param x_amzn_idempotency_token [String] A unique token/requestId provided with each call to ensure idempotency.
      # @param add_inventory_request_body [Hash] List of items to add to Sandbox inventory.
      # @return [Peddler::Response] The API response
      def add_inventory(x_amzn_idempotency_token, add_inventory_request_body)
        must_sandbox!

        path = "/fba/inventory/v1/items/inventory"
        body = add_inventory_request_body
        parser = Peddler::Types::FBAInventoryV1::AddInventoryResponse if typed?
        post(path, body:, parser:)
      end

      private

      def load_types
        require "peddler/types/fba_inventory_v1"
      end
    end
  end
end
