# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module AmazonWarehousingAndDistribution20240509
      # Represents the ineligibility reason for one SKU.
      SkuIneligibilityReason = Structure.new do
        # @return [String] Code for the SKU ineligibility.
        attribute(:code, String)

        # @return [String] Detailed description of the SKU ineligibility.
        attribute(:description, String)
      end
    end
  end
end
