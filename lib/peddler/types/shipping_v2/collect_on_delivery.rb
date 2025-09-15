# frozen_string_literal: true

require "peddler/types/shipping_v2/currency"

module Peddler
  module Types
    module ShippingV2
      # The amount to collect on delivery.
      CollectOnDelivery = Structure.new do
        # @return [Currency]
        attribute(:amount, Currency)
      end
    end
  end
end
