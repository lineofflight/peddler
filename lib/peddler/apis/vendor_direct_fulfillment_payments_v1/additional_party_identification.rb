# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentPaymentsV1
      # An additional corporate or fiscal registration identifier for a party.
      AdditionalPartyIdentification = Structure.new do
        # @return [String] The value of the additional party identifier.
        attribute(:identification_number, String, null: false, from: "identificationNumber")

        # @return [String] The type of the additional party identifier.
        attribute(:identification_type, String, null: false, from: "identificationType")
      end
    end
  end
end
