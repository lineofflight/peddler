# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module AmazonWarehousingAndDistribution20240509
      # The expiration details of the inventory. This object will only appear if the details parameter in the request is
      # set to `SHOW`.
      ExpirationDetails = Structure.new do
        # @return [String] The expiration date of the SKU.
        attribute(:expiration, String)

        # @return [Integer] The quantity that is present in AWD.
        attribute(:onhand_quantity, Integer, from: "onhandQuantity")
      end
    end
  end
end
