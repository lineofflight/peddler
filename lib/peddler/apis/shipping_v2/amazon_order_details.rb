# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # Amazon order information. This is required if the shipment source channel is Amazon.
      AmazonOrderDetails = Structure.new do
        # @return [String] The Amazon order ID associated with the Amazon order fulfilled by this shipment.
        attribute(:order_id, String, from: "orderId")
      end
    end
  end
end
