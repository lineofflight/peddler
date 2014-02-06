require 'peddler/request'
require 'mws/orders/parsers/orders'

module MWS
  module Orders
    module Requests
      class Orders < ::Peddler::Request
        def get(*amazon_order_ids)
          parameters('GetOrder')
            .update(amazon_order_id: amazon_order_ids)
            .format_structured_lists!
            .camelize_keys!

          execute
        end

        def list(options)
          options[:marketplace_id] ||= client.marketplace_id

          parameters('ListOrders')
            .update(options)
            .timestamp!
            .format_structured_lists!
            .camelize_keys!

          execute
        end

        def list_by_next_token(token = next_token)
          return unless token

          parameters('ListOrdersByNextToken')
            .update(next_token: token)
            .camelize_keys!

          execute
        end
      end
    end
  end
end
