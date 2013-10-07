require 'mws/orders/parsers/order'
require 'peddler/parsers/collection'
require 'peddler/parsers/tokenable'

module MWS
  module Orders
    module Parsers
      class Orders < ::Peddler::Parsers::Collection
        include ::Peddler::Parsers::Tokenable

        def each(&blk)
          order_nodes.each { |node| yield Order.new(node) }
        end

        private

        def order_nodes
          xpath('Orders/Order')
        end
      end
    end
  end
end
