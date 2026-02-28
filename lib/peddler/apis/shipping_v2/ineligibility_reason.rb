# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The reason why a shipping service offering is ineligible.
      IneligibilityReason = Structure.new do
        # @return [String]
        attribute(:code, String, null: false)

        # @return [String] The ineligibility reason.
        attribute(:message, String, null: false)
      end
    end
  end
end
