require 'mws/orders/requests/orders'
require 'mws/orders/requests/order_items'
require 'mws/orders/requests/service_status'
require 'peddler/client'

module MWS
  module Orders
    class Client < ::Peddler::Client
      path 'Orders/2011-01-01'

      # Public: Get one or more orders.
      #
      # amazon_order_ids - One or more String Amazon order ids.
      #
      # Examples
      #
      #   client.get_order('123-1234567-1234567')
      #
      # Returns an enumerable list of Orders.
      def_delegator :orders, :get, :get_order

      # Public: List orders created or updated during a specified time frame.
      #
      # options - The Hash query parameters used to narrow the list. Refer to
      #           the MWS Orders API for available parameters.
      #
      # Examples
      #
      #   client.list_orders(created_after: 1.week.ago)
      #
      # Returns an enumerable list of Orders.
      def_delegator :orders, :list, :list_orders

      # Public: List the next page of orders using the NextToken parameter.
      #
      # token - A String token (default: The token returned in the last
      #         request).
      #
      # Examples
      #
      #   client.list_orders_by_next_token
      #
      # Returns an enumerable list of Orders or false if there are no more pages
      # left.
      def_delegator :orders, :list_by_next_token, :list_orders_by_next_token

      # Public: List order items for an amazon order.
      #
      # amazon_order_id - The String Amazon order id.
      #
      # Examples
      #
      #   client.list_order_items('123-1234567-1234567')
      #
      # Returns an enumerable list of Order Items.
      def_delegator :order_items, :list, :list_order_items

      # Public: List the next page of order items using the NextToken
      # parameter.
      #
      # token - A String token (default: The token returned in the last
      #         request).
      #
      # Examples
      #
      #   client.list_order_items_by_next_token
      #
      # Returns an enumerable list of Order Items or false if there are no more
      # pages left.
      def_delegator :order_items, :list_by_next_token, :list_order_items_by_next_token

      # Public: Get the service status of the API.
      #
      # Examples
      #
      #   client.get_service_status
      #
      # Returns the Service Status.
      def_delegator :service_status, :get, :get_service_status

      private

      def orders
        @orders ||= Requests::Orders.new(self)
      end

      def order_items
        @order_items ||= Requests::OrderItems.new(self)
      end

      def service_status
        @service_status ||= Requests::ServiceStatus.new(self)
      end
    end
  end
end
