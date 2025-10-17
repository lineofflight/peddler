# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV1
      # Item in the container.
      ContainerItem = Structure.new do
        # @return [Float] The quantity of the items of this type in the container.
        attribute(:quantity, Float)

        # @return [String] A descriptive title of the item.
        attribute(:title, String)

        # @return [Money] The unit price of an item of this type (the total value of this item type in the container is
        #   unitPrice x quantity).
        attribute(:unit_price, Money, from: "unitPrice")

        # @return [Weight] The unit weight of an item of this type (the total weight of this item type in the container
        #   is unitWeight x quantity).
        attribute(:unit_weight, Weight, from: "unitWeight")
      end
    end
  end
end
