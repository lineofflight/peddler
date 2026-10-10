# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Orders20260101
      # Tax registration information for an entity associated with the order.
      OrderTaxRegistration = Structure.new do
        # The type of entity that the tax registration belongs to.
        #
        # **Possible values**:
        # - `BUYER` (Indicates that this is the buyer's tax registration information) - `MERCHANT` (Indicates that this
        # is the merchant's tax registration information) - `MARKETPLACE` (Indicates that this is the marketplace's tax
        # registration information)
        attribute?(:entity_type, String, from: "entityType")

        # The legal name associated with the tax registration.
        attribute?(:legal_name, String, from: "legalName")

        # The address associated with the tax registration.
        attribute?(:tax_registration_address, CustomerAddress, from: "taxRegistrationAddress")

        # Additional attributes related to the tax registration.
        attribute?(:tax_registration_attributes, [TaxRegistrationAttribute], from: "taxRegistrationAttributes")

        # The tax registration number that identifies the entity for tax purposes.
        attribute?(:tax_registration_number, String, from: "taxRegistrationNumber")

        # The type of the tax registration number.
        #
        # **Possible values**: `BUSINESS`, `VAT`, `CST`, `CPF`, `CNPJ`
        attribute?(:tax_registration_type, String, from: "taxRegistrationType")
      end
    end
  end
end
