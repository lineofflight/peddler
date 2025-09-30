# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The preferred location to leave packages at the destination address.
      DropOffLocation = Structure.new do
        # @return [String] Specifies the preferred location to leave the package at the destination address.
        attribute(:type, String)

        # @return [Hash] Additional information about the drop-off location that can vary depending on the type of
        # drop-off location specified in the `type` field.
        # If the `type` is set to `FALLBACK_NEIGHBOR_DELIVERY`, the `attributes` object should include the exact keys
        # `neighborName` and `houseNumber` to provide the name and house number of the designated neighbor.
        attribute?(:attributes, Hash)
      end
    end
  end
end
