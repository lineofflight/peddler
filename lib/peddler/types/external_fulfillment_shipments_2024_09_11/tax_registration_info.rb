# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_shipments_2024_09_11/address"

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # Tax registration details of the entity. Applicable to direct fulfillment shipments.
      TaxRegistrationInfo = Structure.new do
        # @return [Address] The address associated with the tax registration number.
        attribute?(:address, Address)

        # @return [String] Tax registration message that can be used for additional tax related details.
        attribute?(:messages, String)

        # @return [String] The tax registration number for the party. For example, their VAT ID.
        attribute?(:number, String)

        # @return [String] Tax registration type for the entity
        attribute?(:type, String)
      end
    end
  end
end
