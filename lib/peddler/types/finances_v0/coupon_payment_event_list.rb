# frozen_string_literal: true

require "peddler/types/finances_v0/coupon_payment_event"

module Peddler
  module Types
    module FinancesV0
      # A list of coupon payment event information.
      class CouponPaymentEventList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| CouponPaymentEvent.parse(item) })
          end
        end
      end
    end
  end
end
