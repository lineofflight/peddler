# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_shipping_v1/address"

module Peddler
  module Types
    module VendorDirectFulfillmentShippingV1
      # Tax registration details of the entity.
      TaxRegistrationDetails = Structure.new do
        # @return [String] Tax registration type for the entity.
        attribute(:tax_registration_type, String, from: "taxRegistrationType")

        # @return [String] Tax registration number for the party. For example, VAT ID.
        attribute(:tax_registration_number, String, from: "taxRegistrationNumber")

        # @return [Address] Address associated with the tax registration number.
        attribute(:tax_registration_address, Address, from: "taxRegistrationAddress")

        # @return [String] Tax registration message that can be used for additional tax related details.
        attribute(:tax_registration_messages, String, from: "taxRegistrationMessages")
      end
    end
  end
end
