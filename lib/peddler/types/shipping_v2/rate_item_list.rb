# frozen_string_literal: true

require "peddler/types/shipping_v2/rate_item"

module Peddler
  module Types
    module ShippingV2
      # A list of RateItem
      class RateItemList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| RateItem.parse(item) })
          end
        end
      end
    end
  end
end
