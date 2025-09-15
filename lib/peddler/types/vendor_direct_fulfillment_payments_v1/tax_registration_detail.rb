# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_payments_v1/address"

module Peddler
  module Types
    module VendorDirectFulfillmentPaymentsV1
      # Tax registration details of the entity.
      TaxRegistrationDetail = Structure.new do
        # @return [String] Tax registration type for the entity.
        attribute(:tax_registration_type, String, from: "taxRegistrationType")

        # @return [String] Tax registration number for the entity. For example, VAT ID, Consumption Tax ID.
        attribute(:tax_registration_number, String, from: "taxRegistrationNumber")

        # @return [Address] Address associated with the tax registration number.
        attribute(:tax_registration_address, Address, from: "taxRegistrationAddress")

        # @return [String] Tax registration message that can be used for additional tax related details.
        attribute(:tax_registration_message, String, from: "taxRegistrationMessage")
      end
    end
  end
end
