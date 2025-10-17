# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module Economics20240315
      # Monetary amount with the corresponding currency code.
      Amount = Structure.new do
        # @return [Float] The amount.
        attribute?(:amount, Float, null: false)

        # @return [String] Currency code of the amount in ISO 4217 format.
        attribute?(:currency_code, String, null: false, from: "currencyCode")
      end
    end
  end
end
