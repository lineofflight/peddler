# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner APIs for Fulfillment Outbound
    #
    # The Selling Partner API for Fulfillment Outbound lets you create applications that help a seller fulfill
    # Multi-Channel Fulfillment orders using their inventory in Amazon's fulfillment network. You can get information on
    # both potential and existing fulfillment orders.
    class FulfillmentOutbound20200701 < API
      # Returns a list of fulfillment order previews based on shipping criteria that you specify.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param [Hash] body GetFulfillmentPreviewRequest parameter
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def get_fulfillment_preview(body, rate_limit: 2.0)
        path = "/fba/outbound/2020-07-01/fulfillmentOrders/preview"

        meter(rate_limit).post(path, body:)
      end

      # Returns delivery options that include an estimated delivery date and offer expiration, based on criteria that
      # you specify.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param [Hash] body GetDeliveryOffersRequest parameter
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def delivery_offers(body, rate_limit: 5.0)
        path = "/fba/outbound/2020-07-01/deliveryOffers"

        meter(rate_limit).post(path, body:)
      end

      # Returns a list of fulfillment orders fulfilled after (or at) a specified date-time, or indicated by the next
      # token parameter.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param [String] query_start_date A date used to select fulfillment orders that were last updated after (or at) a
      #   specified time. An update is defined as any change in fulfillment order status, including the creation of a
      #   new fulfillment order.
      # @param [String] next_token A string token returned in the response to your previous request.
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def list_all_fulfillment_orders(query_start_date: nil, next_token: nil, rate_limit: 2.0)
        path = "/fba/outbound/2020-07-01/fulfillmentOrders"
        params = {
          "queryStartDate" => query_start_date,
          "nextToken" => next_token,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Requests that Amazon ship items from the seller's inventory in Amazon's fulfillment network to a destination
      # address.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param [Hash] body CreateFulfillmentOrderRequest parameter
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def create_fulfillment_order(body, rate_limit: 2.0)
        path = "/fba/outbound/2020-07-01/fulfillmentOrders"

        meter(rate_limit).post(path, body:)
      end

      # Returns delivery tracking information for a package in an outbound shipment for a Multi-Channel Fulfillment
      # order.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param [Integer] package_number The unencrypted package identifier returned by the `getFulfillmentOrder`
      #   operation.
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def get_package_tracking_details(package_number, rate_limit: 2.0)
        path = "/fba/outbound/2020-07-01/tracking"
        params = {
          "packageNumber" => package_number,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Returns a list of return reason codes for a seller SKU in a given marketplace. The parameters for this operation
      # may contain special characters that require URL encoding. To avoid errors with SKUs when encoding URLs, refer to
      # [URL Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding).
      #
      # @note This operation can make a dynamic sandbox call.
      # @param [String] seller_sku The seller SKU for which return reason codes are required.
      # @param [String] marketplace_id The marketplace for which the seller wants return reason codes.
      # @param [String] seller_fulfillment_order_id The identifier assigned to the item by the seller when the
      #   fulfillment order was created. The service uses this value to determine the marketplace for which the seller
      #   wants return reason codes.
      # @param [String] language The language that the `TranslatedDescription` property of the `ReasonCodeDetails`
      #   response object should be translated into.
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def list_return_reason_codes(seller_sku, marketplace_id: nil, seller_fulfillment_order_id: nil, language: nil,
        rate_limit: 2.0)

        path = "/fba/outbound/2020-07-01/returnReasonCodes"
        params = {
          "sellerSku" => seller_sku,
          "marketplaceId" => marketplace_id,
          "sellerFulfillmentOrderId" => seller_fulfillment_order_id,
          "language" => language,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Creates a fulfillment return.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param [Hash] body CreateFulfillmentReturnRequest parameter
      # @param [String] seller_fulfillment_order_id An identifier assigned by the seller to the fulfillment order at the
      #   time it was created. The seller uses their own records to find the correct `SellerFulfillmentOrderId` value
      #   based on the buyer's request to return items.
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def create_fulfillment_return(body, seller_fulfillment_order_id, rate_limit: 2.0)
        path = "/fba/outbound/2020-07-01/fulfillmentOrders/#{seller_fulfillment_order_id}/return"

        meter(rate_limit).put(path, body:)
      end

      # Returns the fulfillment order indicated by the specified order identifier.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param [String] seller_fulfillment_order_id The identifier assigned to the item by the seller when the
      #   fulfillment order was created.
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def get_fulfillment_order(seller_fulfillment_order_id, rate_limit: 2.0)
        path = "/fba/outbound/2020-07-01/fulfillmentOrders/#{seller_fulfillment_order_id}"

        meter(rate_limit).get(path)
      end

      # Updates and/or requests shipment for a fulfillment order with an order hold on it.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param [Hash] body UpdateFulfillmentOrderRequest parameter
      # @param [String] seller_fulfillment_order_id The identifier assigned to the item by the seller when the
      #   fulfillment order was created.
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def update_fulfillment_order(body, seller_fulfillment_order_id, rate_limit: 2.0)
        path = "/fba/outbound/2020-07-01/fulfillmentOrders/#{seller_fulfillment_order_id}"

        meter(rate_limit).put(path, body:)
      end

      # Requests that Amazon stop attempting to fulfill the fulfillment order indicated by the specified order
      # identifier.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param [String] seller_fulfillment_order_id The identifier assigned to the item by the seller when the
      #   fulfillment order was created.
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def cancel_fulfillment_order(seller_fulfillment_order_id, rate_limit: 2.0)
        path = "/fba/outbound/2020-07-01/fulfillmentOrders/#{seller_fulfillment_order_id}/cancel"

        meter(rate_limit).put(path)
      end

      # Requests that Amazon update the status of an order in the sandbox testing environment. This is a sandbox-only
      # operation and must be directed to a sandbox endpoint. Refer to [Fulfillment Outbound Dynamic Sandbox
      # Guide](https://developer-docs.amazon.com/sp-api/docs/fulfillment-outbound-dynamic-sandbox-guide) and [Selling
      # Partner API sandbox](https://developer-docs.amazon.com/sp-api/docs/the-selling-partner-api-sandbox) for more
      # information.
      #
      # @note This operation can make a dynamic sandbox call.
      # @note This operation is sandbox-only.
      # @param [String] seller_fulfillment_order_id The identifier assigned to the item by the seller when the
      #   fulfillment order was created.
      # @param [Hash] body The identifier assigned to the item by the seller when the fulfillment order was created.
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def submit_fulfillment_order_status_update(seller_fulfillment_order_id, body, rate_limit: nil)
        path = "/fba/outbound/2020-07-01/fulfillmentOrders/#{seller_fulfillment_order_id}/status"

        put(path, body:)
      end

      # Returns a list of features available for Multi-Channel Fulfillment orders in the marketplace you specify, and
      # whether the seller for which you made the call is enrolled for each feature.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param [String] marketplace_id The marketplace for which to return the list of features.
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def get_features(marketplace_id, rate_limit: 2.0)
        path = "/fba/outbound/2020-07-01/features"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Returns a list of inventory items that are eligible for the fulfillment feature you specify.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param [String] marketplace_id The marketplace for which to return a list of the inventory that is eligible for
      #   the specified feature.
      # @param [String] feature_name The name of the feature for which to return a list of eligible inventory.
      # @param [String] next_token A string token returned in the response to your previous request that is used to
      #   return the next response page. A value of null will return the first page.
      # @param [String] query_start_date A date that you can use to select inventory that has been updated since a
      #   specified date. An update is defined as any change in feature-enabled inventory availability. The date must be
      #   in the format yyyy-MM-ddTHH:mm:ss.sssZ
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def get_feature_inventory(marketplace_id, feature_name, next_token: nil, query_start_date: nil, rate_limit: 2.0)
        path = "/fba/outbound/2020-07-01/features/inventory/#{feature_name}"
        params = {
          "marketplaceId" => marketplace_id,
          "nextToken" => next_token,
          "queryStartDate" => query_start_date,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Returns the number of items with the sellerSKU you specify that can have orders fulfilled using the specified
      # feature. Note that if the sellerSKU isn't eligible, the response will contain an empty skuInfo object. The
      # parameters for this operation may contain special characters that require URL encoding. To avoid errors with
      # SKUs when encoding URLs, refer to [URL Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding).
      #
      # @note This operation can make a dynamic sandbox call.
      # @param [String] marketplace_id The marketplace for which to return the count.
      # @param [String] feature_name The name of the feature.
      # @param [String] seller_sku Used to identify an item in the given marketplace. `SellerSKU` is qualified by the
      #   seller's `SellerId`, which is included with every operation that you submit.
      # @param [Float] rate_limit Requests per second
      # @return [Hash] The API response
      def get_feature_sku(marketplace_id, feature_name, seller_sku, rate_limit: 2.0)
        path = "/fba/outbound/2020-07-01/features/inventory/#{feature_name}/#{seller_sku}"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact

        meter(rate_limit).get(path, params:)
      end
    end
  end
end
