# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Represents the ineligibility reason for one SKU.
      SKUIneligibilityReason = Structure.new do
        # @return [String] Code for the SKU ineligibility.
        attribute(:code, String, null: false)

        # @return [String] Detailed description of the SKU ineligibility.
        attribute(:description, String, null: false)
      end
    end
  end
end
