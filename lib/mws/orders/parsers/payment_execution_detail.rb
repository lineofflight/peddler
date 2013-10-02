require 'mws/orders/parsers/payment_execution_detail_item'
require 'peddler/parsers/collection'

module MWS
  module Orders
    module Parsers
      class PaymentExecutionDetail < ::Peddler::Parsers::Collection
        def each(&blk)
          payment_execution_detail_item_nodes.each { |node| yield PaymentExecutionDetailItem.new(node) }
        end

        private

        def payment_execution_detail_item_nodes
          xpath('PaymentExecutionDetailItem')
        end
      end
    end
  end
end
