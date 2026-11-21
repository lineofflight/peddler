# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # Liquid volume.
      LiquidVolume = Structure.new do
        # The unit of measurement. Known values: `ML`, `L`, `FL_OZ`, `GAL`, `PT`, `QT`, `C`.
        attribute(:unit, String, null: false, from: "Unit")

        # The measurement value.
        attribute(:value, Float, null: false, from: "Value")
      end
    end
  end
end
