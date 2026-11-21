# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # Number of units with their corresponding monetary value.
      UnitsWithValue = Structure.new do
        # Number of units.
        attribute?(:units, String)

        # Monetary value of the units.
        attribute?(:value, Amount)
      end
    end
  end
end
