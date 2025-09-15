# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module VendorOrdersV1
      # Tax registration details of the entity.
      TaxRegistrationDetails = Structure.new do
        # @return [String] Tax registration type for the entity.
        attribute(:tax_registration_type, String, from: "taxRegistrationType")

        # @return [String] Tax registration number for the entity. For example, VAT ID.
        attribute(:tax_registration_number, String, from: "taxRegistrationNumber")
      end
    end
  end
end
