# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # Tax registration details of the entity. Applicable only to direct fulfillment shipments.
      TaxRegistrationInfo = Structure.new do
        # @return [Address] The address associated with the tax registration number.
        attribute?(:address, Address)

        # @return [String] Tax registration message that can be used for additional tax related details.
        attribute?(:messages, String)

        # @return [String] The tax registration number for the party. For example, their VAT ID.
        attribute?(:number, String)

        # @return [String] Tax registration type for the entity. Known values: `VAT`, `GST`.
        attribute?(:type, String)
      end
    end
  end
end
