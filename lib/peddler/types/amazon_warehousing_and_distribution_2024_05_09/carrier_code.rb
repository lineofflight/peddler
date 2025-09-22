# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module AmazonWarehousingAndDistribution20240509
      # Identifies the carrier that will deliver the shipment.
      CarrierCode = Structure.new do
        # @return [String] Denotes the carrier type.
        attribute(:carrier_code_type, String, from: "carrierCodeType")

        # @return [String] Value of the carrier code.
        attribute(:carrier_code_value, String, from: "carrierCodeValue")
      end
    end
  end
end
