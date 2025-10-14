# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorShipmentsV1
      # Tax registration details of the entity.
      TaxRegistrationDetails = Structure.new do
        # @return [String] Tax registration number for the entity. For example, VAT ID.
        attribute(:tax_registration_number, String, from: "taxRegistrationNumber")

        # @return [String] Tax registration type for the entity.
        attribute(:tax_registration_type, String, from: "taxRegistrationType")
      end
    end
  end
end
