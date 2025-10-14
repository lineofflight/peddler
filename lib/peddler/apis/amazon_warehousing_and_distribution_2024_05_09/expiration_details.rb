# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # The expiration details of the inventory. This object will only appear if the details parameter in the request is
      # set to `SHOW`.
      ExpirationDetails = Structure.new do
        # @return [Time] The expiration date of the SKU.
        attribute?(:expiration, Time)

        # @return [Integer] The quantity that is present in AWD.
        attribute?(:onhand_quantity, Integer, from: "onhandQuantity")
      end
    end
  end
end
