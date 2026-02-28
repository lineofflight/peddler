# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The drop-off location at the destination address.
      DropOffLocation = Structure.new do
        # @return [String] The drop-off location type at the destination address.
        attribute(:type, String)

        # @return [Hash] Additional information about the drop-off location. This information can vary depending on the
        #   type of drop-off location specified in the `type` field.
        #
        # If the `type` is set to `FALLBACK_NEIGHBOR_DELIVERY`, the `attributes` object must include the keys
        #   `neighborName` and `houseNumber` to provide the name and house number of the designated neighbor.
        #
        # For `RECEPTIONIST` type, the `attributes` object may include a `recipientName` field that contains the name of
        #   the person who received or will receive the package.
        attribute?(:attributes, Hash)
      end
    end
  end
end
