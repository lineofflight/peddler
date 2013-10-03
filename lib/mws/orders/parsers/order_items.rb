require 'mws/orders/parsers/order_item'
require 'peddler/parsers/collection'

module MWS
  module Orders
    module Parsers
      class OrderItems < ::Peddler::Parsers::Collection
        def each(&blk)
          order_item_nodes.each { |node| yield OrderItem.new(node) }
        end

        private

        def order_item_nodes
          xpath('OrderItems/OrderItem')
        end
      end
    end
  end
end
