require 'peddler/request'
require 'mws/orders/parsers/orders'

module MWS
  module Orders
    module Requests
      class Orders < ::Peddler::Request
        def get(*amazon_order_ids)
          parameters(:get_order)
            .update(amazon_order_id: amazon_order_ids)
            .format_structured_lists!
            .camelize_keys!

          execute
        end

        def list(options)
          options[:marketplace_id] ||= client.marketplace_id

          parameters(:list_orders)
            .update(options)
            .timestamp!
            .format_structured_lists!
            .camelize_keys!

          execute
        end

        def list_by_next_token
          parameters(:list_orders_by_next_token)
            .update(next_token: next_token)
            .camelize_keys!

          execute
        end
      end
    end
  end
end
