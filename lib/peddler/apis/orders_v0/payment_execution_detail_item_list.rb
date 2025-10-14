# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class OrdersV0
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
