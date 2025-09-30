# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_orders_2021_12_28/address"

module Peddler
  module Types
    module VendorDirectFulfillmentOrders20211228
      # Tax registration details of the entity.
      TaxRegistrationDetails = Structure.new do
        # @return [String] Tax registration type for the entity.
        attribute?(:tax_registration_type, String, from: "taxRegistrationType")

        # @return [String] Tax registration number for the party. For example, VAT ID.
        attribute(:tax_registration_number, String, from: "taxRegistrationNumber")

        # @return [Address] Address associated with the tax registration number.
        attribute?(:tax_registration_address, Address, from: "taxRegistrationAddress")

        # @return [String] Tax registration message that can be used for additional tax related details.
        attribute?(:tax_registration_messages, String, from: "taxRegistrationMessages")
      end
    end
  end
end
