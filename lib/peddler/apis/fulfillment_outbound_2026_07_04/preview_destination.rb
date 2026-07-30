# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # The destination of the fulfillment.
      PreviewDestination = Structure.new do
        # @return [Address]
        attribute(:delivery_address, Address, null: false, from: "deliveryAddress")
      end
    end
  end
end
