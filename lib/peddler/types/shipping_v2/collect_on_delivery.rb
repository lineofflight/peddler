# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/money"
require "structure"

module Peddler
  module Types
    module ShippingV2
      # The amount to collect on delivery.
      CollectOnDelivery = Structure.new do
        # @return [Money]
        attribute(:amount, Money)
      end
    end
  end
end
