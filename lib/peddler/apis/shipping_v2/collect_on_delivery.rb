# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The amount to collect on delivery.
      CollectOnDelivery = Structure.new do
        # @return [Money]
        attribute(:amount, Money, null: false)
      end
    end
  end
end
