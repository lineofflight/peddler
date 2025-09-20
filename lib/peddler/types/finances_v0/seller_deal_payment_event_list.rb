# frozen_string_literal: true

require "peddler/types/finances_v0/seller_deal_payment_event"

module Peddler
  module Types
    module FinancesV0
      # A list of payment events for deal-related fees.
      class SellerDealPaymentEventList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| SellerDealPaymentEvent.parse(item) })
          end
        end
      end
    end
  end
end
