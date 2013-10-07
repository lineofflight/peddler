require 'mws/orders/parsers/order_item'
require 'peddler/parsers/collection'
require 'peddler/parsers/tokenable'

module MWS
  module Orders
    module Parsers
      class OrderItems < ::Peddler::Parsers::Collection
        include ::Peddler::Parsers::Tokenable

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
