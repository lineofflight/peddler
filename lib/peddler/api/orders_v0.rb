# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Orders
    #
    # Use the Orders Selling Partner API to programmatically retrieve order information. With this API, you can develop
    # fast, flexible, and custom applications to manage order synchronization, perform order research, and create
    # demand-based decision support tools. _Note:_ For the JP, AU, and SG marketplaces, the Orders API supports orders
    # from 2016 onward. For all other marketplaces, the Orders API supports orders for the last two years (orders older
    # than this don't show up in the response).
    class OrdersV0 < API
      # Returns orders that are created or updated during the specified time period. If you want to return specific
      # types of orders, you can apply filters to your request. `NextToken` doesn't affect any filters that you include
      # in your request; it only impacts the pagination for the filtered orders response.
      #
      # @param [String] created_after Use this date to select orders created after (or at) a specified time. Only orders
      #   placed after the specified time are returned. The date must be in [ISO
      #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format. **Note**: Either the `CreatedAfter`
      #   parameter or the `LastUpdatedAfter` parameter is required. Both cannot be empty. `LastUpdatedAfter` and
      #   `LastUpdatedBefore` cannot be set when `CreatedAfter` is set.
      # @param [String] created_before Use this date to select orders created before (or at) a specified time. Only
      #   orders placed before the specified time are returned. The date must be in [ISO
      #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format. **Note**: `CreatedBefore` is optional
      #   when `CreatedAfter` is set. If specified, `CreatedBefore` must be equal to or after the `CreatedAfter` date
      #   and at least two minutes before current time.
      # @param [String] last_updated_after Use this date to select orders that were last updated after (or at) a
      #   specified time. An update is defined as any change in order status, including the creation of a new order.
      #   Includes updates made by Amazon and by the seller. The date must be in [ISO
      #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format. **Note**: Either the `CreatedAfter`
      #   parameter or the `LastUpdatedAfter` parameter is required. Both cannot be empty. `CreatedAfter` or
      #   `CreatedBefore` cannot be set when `LastUpdatedAfter` is set.
      # @param [String] last_updated_before Use this date to select orders that were last updated before (or at) a
      #   specified time. An update is defined as any change in order status, including the creation of a new order.
      #   Includes updates made by Amazon and by the seller. The date must be in [ISO
      #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format. **Note**: `LastUpdatedBefore` is
      #   optional when `LastUpdatedAfter` is set. But if specified, `LastUpdatedBefore` must be equal to or after the
      #   `LastUpdatedAfter` date and at least two minutes before current time.
      # @param [Array<String>] order_statuses A list of `OrderStatus` values used to filter the results. **Possible
      #   values:** - `PendingAvailability` (This status is available for pre-orders only. The order has been placed,
      #   payment has not been authorized, and the release date of the item is in the future.) - `Pending` (The order
      #   has been placed but payment has not been authorized.) - `Unshipped` (Payment has been authorized and the order
      #   is ready for shipment, but no items in the order have been shipped.) - `PartiallyShipped` (One or more, but
      #   not all, items in the order have been shipped.) - `Shipped` (All items in the order have been shipped.) -
      #   `InvoiceUnconfirmed` (All items in the order have been shipped. The seller has not yet given confirmation to
      #   Amazon that the invoice has been shipped to the buyer.) - `Canceled` (The order has been canceled.) -
      #   `Unfulfillable` (The order cannot be fulfilled. This state applies only to Multi-Channel Fulfillment orders.)
      # @param [Array<String>] marketplace_ids A list of `MarketplaceId` values. Used to select orders that were placed
      #   in the specified marketplaces. Refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids) for a complete list of `marketplaceId`
      #   values.
      # @param [Array<String>] fulfillment_channels A list that indicates how an order was fulfilled. Filters the
      #   results by fulfillment channel. **Possible values**: `AFN` (fulfilled by Amazon), `MFN` (fulfilled by seller).
      # @param [Array<String>] payment_methods A list of payment method values. Use this field to select orders that
      #   were paid with the specified payment methods. **Possible values**: `COD` (cash on delivery), `CVS`
      #   (convenience store), `Other` (Any payment method other than COD or CVS).
      # @param [String] buyer_email The email address of a buyer. Used to select orders that contain the specified email
      #   address.
      # @param [String] seller_order_id An order identifier that is specified by the seller. Used to select only the
      #   orders that match the order identifier. If `SellerOrderId` is specified, then `FulfillmentChannels`,
      #   `OrderStatuses`, `PaymentMethod`, `LastUpdatedAfter`, LastUpdatedBefore, and `BuyerEmail` cannot be specified.
      # @param [Integer] max_results_per_page A number that indicates the maximum number of orders that can be returned
      #   per page. Value must be 1 - 100. Default 100.
      # @param [Array<String>] easy_ship_shipment_statuses A list of `EasyShipShipmentStatus` values. Used to select
      #   Easy Ship orders with statuses that match the specified values. If `EasyShipShipmentStatus` is specified, only
      #   Amazon Easy Ship orders are returned. **Possible values:** - `PendingSchedule` (The package is awaiting the
      #   schedule for pick-up.) - `PendingPickUp` (Amazon has not yet picked up the package from the seller.) -
      #   `PendingDropOff` (The seller will deliver the package to the carrier.) - `LabelCanceled` (The seller canceled
      #   the pickup.) - `PickedUp` (Amazon has picked up the package from the seller.) - `DroppedOff` (The package is
      #   delivered to the carrier by the seller.) - `AtOriginFC` (The packaged is at the origin fulfillment center.) -
      #   `AtDestinationFC` (The package is at the destination fulfillment center.) - `Delivered` (The package has been
      #   delivered.) - `RejectedByBuyer` (The package has been rejected by the buyer.) - `Undeliverable` (The package
      #   cannot be delivered.) - `ReturningToSeller` (The package was not delivered and is being returned to the
      #   seller.) - `ReturnedToSeller` (The package was not delivered and was returned to the seller.) - `Lost` (The
      #   package is lost.) - `OutForDelivery` (The package is out for delivery.) - `Damaged` (The package was damaged
      #   by the carrier.)
      # @param [Array<String>] electronic_invoice_statuses A list of `ElectronicInvoiceStatus` values. Used to select
      #   orders with electronic invoice statuses that match the specified values. **Possible values:** - `NotRequired`
      #   (Electronic invoice submission is not required for this order.) - `NotFound` (The electronic invoice was not
      #   submitted for this order.) - `Processing` (The electronic invoice is being processed for this order.) -
      #   `Errored` (The last submitted electronic invoice was rejected for this order.) - `Accepted` (The last
      #   submitted electronic invoice was submitted and accepted.)
      # @param [String] next_token A string token returned in the response of your previous request.
      # @param [Array<String>] amazon_order_ids A list of `AmazonOrderId` values. An `AmazonOrderId` is an
      #   Amazon-defined order identifier, in 3-7-7 format.
      # @param [String] actual_fulfillment_supply_source_id The `sourceId` of the location from where you want the order
      #   fulfilled.
      # @param [Boolean] is_ispu When true, this order is marked to be picked up from a store rather than delivered.
      # @param [String] store_chain_store_id The store chain store identifier. Linked to a specific store in a store
      #   chain.
      # @param [String] earliest_delivery_date_before Use this date to select orders with a earliest delivery date
      #   before (or at) a specified time. The date must be in [ISO
      #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
      # @param [String] earliest_delivery_date_after Use this date to select orders with a earliest delivery date after
      #   (or at) a specified time. The date must be in [ISO
      #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
      # @param [String] latest_delivery_date_before Use this date to select orders with a latest delivery date before
      #   (or at) a specified time. The date must be in [ISO
      #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
      # @param [String] latest_delivery_date_after Use this date to select orders with a latest delivery date after (or
      #   at) a specified time. The date must be in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601)
      #   format.
      # @return [Hash] The API response
      def get_orders(
        marketplace_ids, created_after: nil, created_before: nil, last_updated_after: nil, last_updated_before: nil,
        order_statuses: nil, fulfillment_channels: nil, payment_methods: nil, buyer_email: nil, seller_order_id: nil,
        max_results_per_page: nil, easy_ship_shipment_statuses: nil, electronic_invoice_statuses: nil, next_token: nil,
        amazon_order_ids: nil, actual_fulfillment_supply_source_id: nil, is_ispu: nil, store_chain_store_id: nil,
        earliest_delivery_date_before: nil, earliest_delivery_date_after: nil, latest_delivery_date_before: nil,
        latest_delivery_date_after: nil
      )
        path = "/orders/v0/orders"
        params = {
          "CreatedAfter" => created_after,
          "CreatedBefore" => created_before,
          "LastUpdatedAfter" => last_updated_after,
          "LastUpdatedBefore" => last_updated_before,
          "OrderStatuses" => order_statuses,
          "MarketplaceIds" => marketplace_ids,
          "FulfillmentChannels" => fulfillment_channels,
          "PaymentMethods" => payment_methods,
          "BuyerEmail" => buyer_email,
          "SellerOrderId" => seller_order_id,
          "MaxResultsPerPage" => max_results_per_page,
          "EasyShipShipmentStatuses" => easy_ship_shipment_statuses,
          "ElectronicInvoiceStatuses" => electronic_invoice_statuses,
          "NextToken" => next_token,
          "AmazonOrderIds" => amazon_order_ids,
          "ActualFulfillmentSupplySourceId" => actual_fulfillment_supply_source_id,
          "IsISPU" => is_ispu,
          "StoreChainStoreId" => store_chain_store_id,
          "EarliestDeliveryDateBefore" => earliest_delivery_date_before,
          "EarliestDeliveryDateAfter" => earliest_delivery_date_after,
          "LatestDeliveryDateBefore" => latest_delivery_date_before,
          "LatestDeliveryDateAfter" => latest_delivery_date_after,
        }.compact

        rate_limit(0.0167).get(path, params:)
      end

      # Returns the order that you specify.
      #
      # @param [String] order_id An Amazon-defined order identifier, in 3-7-7 format.
      # @return [Hash] The API response
      def get_order(order_id)
        path = "/orders/v0/orders/#{order_id}"

        rate_limit(0.5).get(path)
      end

      # Returns buyer information for the order that you specify.
      #
      # @param [String] order_id An `orderId` is an Amazon-defined order identifier, in 3-7-7 format.
      # @return [Hash] The API response
      def get_order_buyer_info(order_id)
        path = "/orders/v0/orders/#{order_id}/buyerInfo"

        rate_limit(0.5).get(path)
      end

      # Returns the shipping address for the order that you specify.
      #
      # @param [String] order_id An `orderId` is an Amazon-defined order identifier, in 3-7-7 format.
      # @return [Hash] The API response
      def get_order_address(order_id)
        path = "/orders/v0/orders/#{order_id}/address"

        rate_limit(0.5).get(path)
      end

      # Returns the fulfillment instructions for the order that you specify.
      #
      # @param [String] order_id An Amazon-defined order identifier, in 3-7-7 format.
      # @return [Hash] The API response
      def get_order_fulfillment_instructions(order_id)
        path = "/orders/v0/orders/#{order_id}/fulfillmentInstructions"

        rate_limit(0.5).get(path)
      end

      # Returns detailed order item information for the order that you specify. If `NextToken` is provided, it's used to
      # retrieve the next page of order items. __Note__: When an order is in the Pending state (the order has been
      # placed but payment has not been authorized), the getOrderItems operation does not return information about
      # pricing, taxes, shipping charges, gift status or promotions for the order items in the order. After an order
      # leaves the Pending state (this occurs when payment has been authorized) and enters the Unshipped, Partially
      # Shipped, or Shipped state, the getOrderItems operation returns information about pricing, taxes, shipping
      # charges, gift status and promotions for the order items in the order.
      #
      # @param [String] order_id An Amazon-defined order identifier, in 3-7-7 format.
      # @param [String] next_token A string token returned in the response of your previous request.
      # @return [Hash] The API response
      def get_order_items(order_id, next_token: nil)
        path = "/orders/v0/orders/#{order_id}/orderItems"
        params = {
          "NextToken" => next_token,
        }.compact

        rate_limit(0.5).get(path, params:)
      end

      # Returns buyer information for the order items in the order that you specify.
      #
      # @param [String] order_id An Amazon-defined order identifier, in 3-7-7 format.
      # @param [String] next_token A string token returned in the response of your previous request.
      # @return [Hash] The API response
      def get_order_items_buyer_info(order_id, next_token: nil)
        path = "/orders/v0/orders/#{order_id}/orderItems/buyerInfo"
        params = {
          "NextToken" => next_token,
        }.compact

        rate_limit(0.5).get(path, params:)
      end

      # Update the shipment status for an order that you specify.
      #
      # @param [String] order_id An Amazon-defined order identifier, in 3-7-7 format.
      # @param [Hash] payload The request body for the `updateShipmentStatus` operation.
      # @return [Hash] The API response
      def update_shipment_status(order_id, payload)
        path = "/orders/v0/orders/#{order_id}/shipment"
        body = payload

        rate_limit(5.0).post(path, body:)
      end

      # Returns regulated information for the order that you specify.
      #
      # @param [String] order_id An Amazon-defined order identifier, in 3-7-7 format.
      # @return [Hash] The API response
      def get_order_regulated_info(order_id)
        path = "/orders/v0/orders/#{order_id}/regulatedInfo"

        rate_limit(0.5).get(path)
      end

      # Updates (approves or rejects) the verification status of an order containing regulated products.
      #
      # @param [String] order_id An Amazon-defined order identifier, in 3-7-7 format.
      # @param [Hash] payload The request body for the `updateVerificationStatus` operation.
      # @return [Hash] The API response
      def update_verification_status(order_id, payload)
        path = "/orders/v0/orders/#{order_id}/regulatedInfo"
        body = payload

        rate_limit(0.5).patch(path, body:)
      end

      # Updates the shipment confirmation status for a specified order.
      #
      # @param [String] order_id An Amazon-defined order identifier, in 3-7-7 format.
      # @param [Hash] payload Request body of `confirmShipment`.
      # @return [Hash] The API response
      def confirm_shipment(order_id, payload)
        path = "/orders/v0/orders/#{order_id}/shipmentConfirmation"
        body = payload

        rate_limit(2.0).post(path, body:)
      end
    end
  end
end
