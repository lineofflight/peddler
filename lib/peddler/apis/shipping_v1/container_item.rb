# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV1
      # Item in the container.
      ContainerItem = Structure.new do
        # @return [Float] The quantity of the items of this type in the container.
        attribute(:quantity, Float, null: false)

        # @return [String] A descriptive title of the item.
        attribute(:title, String, null: false)

        # @return [Money] The unit price of an item of this type (the total value of this item type in the container is
        #   unitPrice x quantity).
        attribute(:unit_price, Money, null: false, from: "unitPrice")

        # @return [Weight] The unit weight of an item of this type (the total weight of this item type in the container
        #   is unitWeight x quantity).
        attribute(:unit_weight, Weight, null: false, from: "unitWeight")
      end
    end
  end
end
