# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FulfillmentInboundV0
      # Contains details about an invalid ASIN
      InvalidASIN = Structure.new do
        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute(:asin, String, from: "ASIN")

        # @return [String] The reason that the ASIN is invalid.
        attribute(:error_reason, String, from: "ErrorReason")
      end
    end
  end
end
