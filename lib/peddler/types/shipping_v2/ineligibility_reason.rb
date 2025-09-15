# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ShippingV2
      # The reason why a shipping service offering is ineligible.
      IneligibilityReason = Structure.new do
        # @return [String]
        attribute(:code, String)

        # @return [String] The ineligibility reason.
        attribute(:message, String)
      end
    end
  end
end
