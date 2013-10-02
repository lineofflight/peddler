require 'peddler/request'
require 'mws/orders/parsers/order_items'

module MWS
  module Orders
    module Requests
      class OrderItems < ::Peddler::Request
        def list(amazon_order_id)
          parameters(:list_order_items)
            .update(amazon_order_id: amazon_order_id)
            .camelize_keys!

          execute
        end

        def list_by_next_token
          parameters(:list_order_items_by_next_token)
            .update(next_token: next_token)
            .camelize_keys!

          execute
        end
      end
    end
  end
end
