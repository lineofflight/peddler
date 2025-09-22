# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentInboundV0
      # The monetary value.
      Amount = Structure.new do
        # @return [String]
        attribute(:currency_code, String, from: "CurrencyCode")

        # @return [Float] The amount.
        attribute(:value, Float, from: "Value")
      end
    end
  end
end
