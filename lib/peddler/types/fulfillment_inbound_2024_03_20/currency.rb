# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The type and amount of currency.
      Currency = Structure.new do
        # @return [Float] Decimal value of the currency.
        attribute(:amount, Float)

        # @return [String] ISO 4217 standard of a currency code.
        attribute(:code, String)
      end
    end
  end
end
