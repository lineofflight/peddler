# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module AmazonWarehousingAndDistribution20240509
      # A response that contains the reference identifiers for the newly created or updated inbound order. Consists of
      # an order ID and version.
      InboundOrderReference = Structure.new do
        # @return [String] Order ID of the inbound order.
        attribute(:order_id, String, from: "orderId")
      end
    end
  end
end
