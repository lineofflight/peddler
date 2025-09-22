# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

module Peddler
  module Types
    module ShippingV2
      # The amount to collect on delivery.
      CollectOnDelivery = Structure.new do
        # @return [Types::Money]
        attribute(:amount, Types::Money)
      end
    end
  end
end
