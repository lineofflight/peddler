# frozen_string_literal: true

require "peddler/types/finances_v0/product_ads_payment_event"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of sponsored products payment events.
      class ProductAdsPaymentEventList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| ProductAdsPaymentEvent.parse(item) }) : new
          end
        end
      end
    end
  end
end
