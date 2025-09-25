# frozen_string_literal: true

# This file is generated. Edit template if necessary.

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
