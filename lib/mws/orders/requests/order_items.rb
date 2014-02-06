require 'peddler/request'
require 'mws/orders/parsers/order_items'

module MWS
  module Orders
    module Requests
      class OrderItems < ::Peddler::Request
        def list(amazon_order_id)
          parameters('ListOrderItems')
            .update(amazon_order_id: amazon_order_id)
            .camelize_keys!

          execute
        end

        def list_by_next_token(token = next_token)
          return unless token

          parameters('ListOrderItemsByNextToken')
            .update(next_token: token)
            .camelize_keys!

          execute
        end
      end
    end
  end
end
