# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/rate_item"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module MerchantFulfillmentV0
      # List of adjustments.
      class AdjustmentItemList < Array
        class << self
          def parse(array)
            new(array.map { |item| RateItem.parse(item) })
          end
        end
      end
    end
  end
end
