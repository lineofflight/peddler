# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v1/currency"
require "peddler/types/shipping_v1/weight"

module Peddler
  module Types
    module ShippingV1
      # Item in the container.
      ContainerItem = Structure.new do
        # @return [Float] The quantity of the items of this type in the container.
        attribute(:quantity, Float)

        # @return [Currency] The unit price of an item of this type (the total value of this item type in the container
        # is unitPrice x quantity).
        attribute(:unit_price, Currency, from: "unitPrice")

        # @return [Weight] The unit weight of an item of this type (the total weight of this item type in the container
        # is unitWeight x quantity).
        attribute(:unit_weight, Weight, from: "unitWeight")

        # @return [String] A descriptive title of the item.
        attribute(:title, String)
      end
    end
  end
end
