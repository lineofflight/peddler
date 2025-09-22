# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # Amazon order information. This is required if the shipment source channel is Amazon.
      AmazonOrderDetails = Structure.new do
        # @return [String] The Amazon order ID associated with the Amazon order fulfilled by this shipment.
        attribute(:order_id, String, from: "orderId")
      end
    end
  end
end
