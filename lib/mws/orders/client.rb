require 'peddler/client'

module MWS
  module Orders
    # With the MWS Orders API, you can list orders created or updated during a
    # time frame you specify or retrieve information about specific orders.
    class Client < ::Peddler::Client
      version "2013-09-01"
      path "/Orders/#{version}"

      # Lists orders
      #
      # @see http://docs.developer.amazonservices.com/en_US/orders/2013-09-01/Orders_ListOrders.html
      # @param opts [Hash]
      # @option opts [String, #iso8601] :created_after
      # @option opts [String, #iso8601] :created_before
      # @option opts [String, #iso8601] :last_updated_after
      # @option opts [String, #iso8601] :last_updated_before
      # @option opts [Array<String>, String] :order_status
      # @option opts [Array<String>, String] :marketplace_id
      # @option opts [Array<String>, String] :fulfillment_channel
      # @option opts [Array<String>, String] :payment_method
      # @option opts [String] :buyer_email
      # @option opts [String] :seller_order_id
      # @option opts [String] :max_results_per_page
      # @option opts [String] :tfm_shipment_status
      # @return [Peddler::XMLParser]
      # rubocop:disable MethodLength
      def list_orders(opts = {})
        opts[:marketplace_id] ||= primary_marketplace_id
        if opts.key?(:tfm_shipment_status)
          opts['TFMShipmentStatus'] = opts.delete(:tfm_shipment_status)
        end

        operation('ListOrders')
          .add(opts)
          .structure!('OrderStatus', 'Status')
          .structure!('FulfillmentChannel', 'Channel')
          .structure!('MarketplaceId', 'Id')
          .structure!('PaymentMethod')
          .structure!('TFMShipmentStatus', 'Status')

        run
      end

      # Lists the next page of orders
      #
      # @see http://docs.developer.amazonservices.com/en_US/orders/2013-09-01/Orders_ListOrdersByNextToken.html
      # @param next_token [String]
      # @return [Peddler::XMLParser]
      def list_orders_by_next_token(next_token)
        operation('ListOrdersByNextToken')
          .add('NextToken' => next_token)

        run
      end

      # Gets one or more orders
      #
      # @see http://docs.developer.amazonservices.com/en_US/orders/2013-09-01/Orders_GetOrder.html
      # @param amazon_order_ids [Array<String>]
      # @return [Peddler::XMLParser]
      def get_order(*amazon_order_ids)
        operation('GetOrder')
          .add('AmazonOrderId' => amazon_order_ids)
          .structure!('AmazonOrderId', 'Id')

        run
      end

      # Lists order items for an order
      #
      # @see http://docs.developer.amazonservices.com/en_US/orders/2013-09-01/Orders_ListOrderItems.html
      # @param amazon_order_id [String]
      # @return [Peddler::XMLParser]
      def list_order_items(amazon_order_id)
        operation('ListOrderItems')
          .add('AmazonOrderId' => amazon_order_id)

        run
      end

      # Lists the next page of order items for an order
      #
      # @see http://docs.developer.amazonservices.com/en_US/orders/2013-09-01/Orders_ListOrderItemsByNextToken.html
      # @param next_token [String]
      # @return [Peddler::XMLParser]
      def list_order_items_by_next_token(next_token)
        operation('ListOrderItemsByNextToken')
          .add('NextToken' => next_token)

        run
      end

      # Gets the service status of the API
      #
      # @see http://docs.developer.amazonservices.com/en_US/orders/2013-09-01/MWS_GetServiceStatus.html
      # @return [Peddler::XMLParser]
      def get_service_status
        operation('GetServiceStatus')
        run
      end
    end
  end
end
