# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentPaymentsV1
      # Tax registration details of the entity.
      TaxRegistrationDetail = Structure.new do
        # Tax registration number for the entity. For example, VAT ID, Consumption Tax ID.
        attribute(:tax_registration_number, String, null: false, from: "taxRegistrationNumber")

        # Address associated with the tax registration number.
        attribute?(:tax_registration_address, Address, from: "taxRegistrationAddress")

        # Tax registration message that can be used for additional tax related details.
        attribute?(:tax_registration_message, String, from: "taxRegistrationMessage")

        # Tax registration type for the entity.
        attribute?(:tax_registration_type, String, from: "taxRegistrationType")
      end
    end
  end
end
