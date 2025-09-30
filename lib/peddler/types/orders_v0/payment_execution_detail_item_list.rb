# frozen_string_literal: true

require "peddler/types/orders_v0/payment_execution_detail_item"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module OrdersV0
      # A list of payment execution detail items.
      class PaymentExecutionDetailItemList < Array
        class << self
          def parse(array)
            new(array.map { |item| PaymentExecutionDetailItem.parse(item) })
          end
        end
      end
    end
  end
end
