# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentShipping20211228
      # Tax registration details of the entity.
      TaxRegistrationDetails = Structure.new do
        # Tax registration number for the party. For example, VAT ID.
        attribute(:tax_registration_number, String, null: false, from: "taxRegistrationNumber")

        # Address associated with the tax registration number.
        attribute?(:tax_registration_address, Address, from: "taxRegistrationAddress")

        # Tax registration message that can be used for additional tax related details.
        attribute?(:tax_registration_messages, String, from: "taxRegistrationMessages")

        # Tax registration type for the entity. Known values: `VAT`, `GST`.
        attribute?(:tax_registration_type, String, from: "taxRegistrationType")
      end
    end
  end
end
