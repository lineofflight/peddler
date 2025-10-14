# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FinancesV0
      # A list of coupon payment event information.
      class CouponPaymentEventList < Array
        class << self
          def parse(array)
            new(array.map { |item| CouponPaymentEvent.parse(item) })
          end
        end
      end
    end
  end
end
