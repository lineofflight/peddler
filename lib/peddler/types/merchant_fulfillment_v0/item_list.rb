# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/item"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module MerchantFulfillmentV0
      # The list of items you want to include in a shipment.
      class ItemList < Array
        class << self
          def parse(array)
            new(array.map { |item| Item.parse(item) })
          end
        end
      end
    end
  end
end
