# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Response containing the reference identifier for the newly created/updated replenishment order consisting of the
      # order ID.
      ReplenishmentOrderReference = Structure.new do
        # @return [String] Order ID of the Replenishment order.
        attribute(:order_id, String, null: false, from: "orderId")
      end
    end
  end
end
