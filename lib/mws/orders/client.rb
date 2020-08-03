# frozen_string_literal: true

require 'peddler/client'

module MWS
  module Orders
    # With the MWS Orders API, you can list orders created or updated during a
    # time frame you specify or retrieve information about specific orders.
    class Client < ::Peddler::Client
      self.version = '2013-09-01'
      self.path = "/Orders/#{version}"

      # Lists orders
      #
      # @note When calling this operation, you must specify a time frame using
      #   either created_after or last_updated_after. When requesting orders by
      #   "Unshipped" status you must also request "PartiallyShipped" orders.
      # @see https://docs.developer.amazonservices.com/en_US/orders-2013-09-01/Orders_ListOrders.html
      # @overload list_orders(*marketplace_id, opts = {})
      #   @param [Array<String>] marketplace_id
      #   @param [Hash] opts
      #   @option opts [String, #iso8601] :created_after
      #   @option opts [String, #iso8601] :created_before
      #   @option opts [String, #iso8601] :last_updated_after
      #   @option opts [String, #iso8601] :last_updated_before
      #   @option opts [Array<String>, String] :order_status
      #   @option opts [Array<String>, String] :fulfillment_channel
      #   @option opts [Array<String>, String] :payment_method
      #   @option opts [String] :buyer_email
      #   @option opts [String] :seller_order_id
      #   @option opts [String] :max_results_per_page
      #   @option opts [String] :tfm_shipment_status
      # @return [Peddler::XMLParser]
      def list_orders(*marketplace_id)
        marketplace_id = marketplace_id.dup
        opts = extract_options(marketplace_id)
        opts['TFMShipmentStatus'] = opts.delete(:tfm_shipment_status) if opts.key?(:tfm_shipment_status)

        operation('ListOrders')
          .add(opts)
          .add('MarketplaceId' => marketplace_id)
          .structure!('OrderStatus', 'Status')
          .structure!('FulfillmentChannel', 'Channel')
          .structure!('MarketplaceId', 'Id')
          .structure!('PaymentMethod')
          .structure!('TFMShipmentStatus', 'Status')
        require_start_time!

        run
      end

      # Lists the next page of orders
      #
      # @see https://docs.developer.amazonservices.com/en_US/orders-2013-09-01/Orders_ListOrdersByNextToken.html
      # @param [String] next_token
      # @return [Peddler::XMLParser]
      def list_orders_by_next_token(next_token)
        operation('ListOrdersByNextToken')
          .add('NextToken' => next_token)

        run
      end

      # Gets one or more orders
      #
      # @see https://docs.developer.amazonservices.com/en_US/orders-2013-09-01/Orders_GetOrder.html
      # @param [Array<String>] amazon_order_ids
      # @return [Peddler::XMLParser]
      def get_order(*amazon_order_ids)
        operation('GetOrder')
          .add('AmazonOrderId' => amazon_order_ids)
          .structure!('AmazonOrderId', 'Id')

        run
      end

      # Lists order items for an order
      #
      # @see https://docs.developer.amazonservices.com/en_US/orders-2013-09-01/Orders_ListOrderItems.html
      # @param [String] amazon_order_id
      # @return [Peddler::XMLParser]
      def list_order_items(amazon_order_id)
        operation('ListOrderItems')
          .add('AmazonOrderId' => amazon_order_id)

        run
      end

      # Lists the next page of order items for an order
      #
      # @see https://docs.developer.amazonservices.com/en_US/orders-2013-09-01/Orders_ListOrderItemsByNextToken.html
      # @param [String] next_token
      # @return [Peddler::XMLParser]
      def list_order_items_by_next_token(next_token)
        operation('ListOrderItemsByNextToken')
          .add('NextToken' => next_token)

        run
      end

      # Gets the service status of the API
      #
      # @see https://docs.developer.amazonservices.com/en_US/orders-2013-09-01/MWS_GetServiceStatus.html
      # @return [Peddler::XMLParser]
      def get_service_status
        operation('GetServiceStatus')
        run
      end

      private

      def require_start_time!
        return if operation.key?('CreatedAfter')
        return if operation.key?('LastUpdatedAfter')

        raise ArgumentError, 'specify created_after or last_updated_after'
      end
    end
  end
end
