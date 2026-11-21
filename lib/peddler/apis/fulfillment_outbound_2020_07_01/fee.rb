# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20200701
      # Fee type and cost.
      Fee = Structure.new do
        # The amount of the fee.
        attribute(:amount, Money, null: false)

        # The type of fee. Known values: `FBAPerUnitFulfillmentFee`, `FBAPerOrderFulfillmentFee`,
        # `FBATransportationFee`, `FBAFulfillmentCODFee`.
        attribute(:name, String, null: false)
      end
    end
  end
end
