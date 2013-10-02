require 'mws/orders/parsers/order'
require 'peddler/parsers/collection'

module MWS
  module Orders
    module Parsers
      class Orders < ::Peddler::Parsers::Collection
        extend Forwardable

        def_delegator :order_nodes, :each

        private

        def order_nodes
          xpath('Order').map { |node| Order.new(node) }
        end
      end
    end
  end
end
