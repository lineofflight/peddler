# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ShippingV2
      # A list of RateItem
      class RateItemList < Array
        class << self
          def parse(array)
            new(array.map { |item| RateItem.parse(item) })
          end
        end
      end
    end
  end
end
