# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Fulfillment Outbound
    #
    # The Selling Partner API for Fulfillment Outbound lets you create applications that help a seller fulfill
    # Multi-Channel Fulfillment orders using their inventory in Amazon's fulfillment network. You can get information on
    # both potential and existing fulfillment orders.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/fulfillment-outbound-api-model/fulfillmentOutbound_2026-07-04.json
    class FulfillmentOutbound20260704 < API
      # Retrieve a list of fulfillment order previews based on shipping criteria that you specify.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param x_amzn_fulfillment_service_id [String] The identifier of the fulfillment service used for this operation.
      # @param body [Hash] The request body schema for the `getOrderPreview` operation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_order_preview(body, x_amzn_fulfillment_service_id: nil, rate_limit: 2.0)
        path = "/fulfillment/outbound/2026-07-04/previews"
        parser = -> { GetOrderPreviewResponse }
        post(path, body:, rate_limit:, parser:)
      end

      # Retrieve delivery options that include an estimated delivery date and offer expiration, based on criteria that
      # you specify.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param x_amzn_fulfillment_service_id [String] The identifier of the fulfillment service used for this operation.
      # @param body [Hash] The request body schema for the `getOffers` operation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_offers(body, x_amzn_fulfillment_service_id: nil, rate_limit: 5.0)
        path = "/fulfillment/outbound/2026-07-04/offers"
        parser = -> { GetOffersResponse }
        post(path, body:, rate_limit:, parser:)
      end

      # Request that Amazon stop attempting to fulfill a fulfillment order.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param x_amzn_fulfillment_service_id [String] The identifier of the fulfillment service used for this operation.
      # @param order_id [String] The ID of the order that you want to cancel.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def cancel_order(order_id, x_amzn_fulfillment_service_id: nil, rate_limit: 2.0)
        path = "/fulfillment/outbound/2026-07-04/orders/#{percent_encode(order_id)}/cancel"
        parser = -> { CancelOrderResponse }
        put(path, rate_limit:, parser:)
      end

      # Request that Amazon update the status of an order in the sandbox testing environment. This is a sandbox-only
      # operation and must be directed to a sandbox endpoint. Refer to [Fulfillment Outbound Dynamic Sandbox
      # Guide](https://developer-docs.amazon.com/sp-api/docs/fulfillment-outbound-dynamic-sandbox-guide) and [Selling
      # Partner API sandbox](https://developer-docs.amazon.com/sp-api/docs/the-selling-partner-api-sandbox) for more
      # information.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param x_amzn_fulfillment_service_id [String] The identifier of the fulfillment service used for this operation.
      # @param order_id [String] The ID of the order that you want to update.
      # @param body [Hash] The new status of the fulfillment order.
      # @return [Peddler::Response] The API response
      def update_order_status(order_id, body, x_amzn_fulfillment_service_id: nil)
        must_sandbox!

        path = "/fulfillment/outbound/2026-07-04/orders/#{percent_encode(order_id)}/status"
        put(path, body:)
      end

      # Update package information for a specific package in a fulfillment order. This is a sandbox-only operation and
      # must be directed to a sandbox endpoint. Refer to [Fulfillment Outbound Dynamic Sandbox
      # Guide](https://developer-docs.amazon.com/sp-api/docs/fulfillment-outbound-dynamic-sandbox-guide) and [Selling
      # Partner API sandbox](https://developer-docs.amazon.com/sp-api/docs/the-selling-partner-api-sandbox) for more
      # information.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param x_amzn_fulfillment_service_id [String] The identifier of the fulfillment service used for this operation.
      # @param order_id [String] The ID of the order that contains the package that you want to update.
      # @param package_id [String] The ID of the package that you want to update.
      # @param body [Hash] The new package information.
      # @return [Peddler::Response] The API response
      def update_package(order_id, package_id, body, x_amzn_fulfillment_service_id: nil)
        must_sandbox!

        path = "/fulfillment/outbound/2026-07-04/orders/#{percent_encode(order_id)}/packages/#{percent_encode(package_id)}"
        put(path, body:)
      end

      # Update and/or request shipment for a fulfillment order with an order hold on it.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param x_amzn_fulfillment_service_id [String] The identifier of the fulfillment service used for this operation.
      # @param order_id [String] The ID of the order that you want to update and/or request shipment of.
      # @param body [Hash] The request body schema for the `updateOrder` operation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def update_order(order_id, body, x_amzn_fulfillment_service_id: nil, rate_limit: 2.0)
        path = "/fulfillment/outbound/2026-07-04/orders/#{percent_encode(order_id)}"
        parser = -> { UpdateOrderResponse }
        put(path, body:, rate_limit:, parser:)
      end

      # Retrieve a fulfillment order.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param x_amzn_fulfillment_service_id [String] The identifier of the fulfillment service used for this operation.
      # @param order_id [String] The ID of the order you want to retrieve.
      # @param shipments [String] Whether to include shipment data in the response. Included by default.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_order(order_id, x_amzn_fulfillment_service_id: nil, shipments: nil, rate_limit: 2.0)
        path = "/fulfillment/outbound/2026-07-04/orders/#{percent_encode(order_id)}"
        params = {
          "shipments" => shipments,
        }.compact
        parser = -> { GetOrderResponse }
        get(path, params:, rate_limit:, parser:)
      end

      # Retrieve a list of fulfillment orders that match the criteria you specify.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param x_amzn_fulfillment_service_id [String] The identifier of the fulfillment service used for this operation.
      # @param updated_after [String] The response includes orders updated after this time. Must be in [ISO
      #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
      # @param page_token [String] A token that you use to retrieve the next page of results. The response includes
      #   `pageToken` when the number of results exceeds the page size. To get the next page of results, call the
      #   operation with this token and include the same arguments as the call that produced the token. To get a
      #   complete list, call this operation until `pageToken` is `null`.
      # @param shipments [String] Whether to include shipment data in the response. Included by default.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def list_orders(x_amzn_fulfillment_service_id: nil, updated_after: nil, page_token: nil, shipments: nil,
        rate_limit: 2.0)
        path = "/fulfillment/outbound/2026-07-04/orders"
        params = {
          "updatedAfter" => updated_after,
          "pageToken" => page_token,
          "shipments" => shipments,
        }.compact
        parser = -> { ListOrdersResponse }
        get(path, params:, rate_limit:, parser:)
      end

      # Request that Amazon ship items from the seller's inventory in Amazon's fulfillment network to a destination
      # address.
      #
      # @note This operation can make a dynamic sandbox call.
      # @param x_amzn_fulfillment_service_id [String] The identifier of the fulfillment service used for this operation.
      # @param body [Hash] The request body schema for the `createOrder` operation.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_order(body, x_amzn_fulfillment_service_id: nil, rate_limit: 2.0)
        path = "/fulfillment/outbound/2026-07-04/orders"
        parser = -> { CreateOrderResponse }
        post(path, body:, rate_limit:, parser:)
      end
    end
  end
end
