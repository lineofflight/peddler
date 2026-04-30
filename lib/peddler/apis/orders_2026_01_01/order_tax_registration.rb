# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Tax registration information for an entity associated with the order.
      OrderTaxRegistration = Structure.new do
        # @return [String] The type of entity that the tax registration belongs to.
        #
        # **Possible values**:
        # - `BUYER` (Indicates that this is the buyer's tax registration information) - `MERCHANT` (Indicates that this
        #   is the merchant's tax registration information) - `MARKETPLACE` (Indicates that this is the marketplace's
        #   tax registration information)
        attribute?(:entity_type, String, from: "entityType")

        # @return [String] The legal name associated with the tax registration.
        attribute?(:legal_name, String, from: "legalName")

        # @return [CustomerAddress] The address associated with the tax registration.
        attribute?(:tax_registration_address, CustomerAddress, from: "taxRegistrationAddress")

        # @return [Array<TaxRegistrationAttribute>] Additional attributes related to the tax registration.
        attribute?(:tax_registration_attributes, [TaxRegistrationAttribute], from: "taxRegistrationAttributes")

        # @return [String] The tax registration number that identifies the entity for tax purposes.
        attribute?(:tax_registration_number, String, from: "taxRegistrationNumber")

        # @return [String] The type of the tax registration number.
        #
        # **Possible values**: `BUSINESS`, `VAT`, `CST`, `CPF`, `CNPJ`
        attribute?(:tax_registration_type, String, from: "taxRegistrationType")
      end
    end
  end
end
