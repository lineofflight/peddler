# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # A response that contains the reference identifier for the newly created or updated outbound order. This includes
      # an order ID.
      OutboundOrderReference = Structure.new do
        # @return [String] outbound order ID.
        attribute(:order_id, String, null: false, from: "orderId")
      end
    end
  end
end
