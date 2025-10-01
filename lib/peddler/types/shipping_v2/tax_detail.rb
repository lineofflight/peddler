# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # Indicates the tax specifications associated with the shipment for customs compliance purposes in certain
      # regions.
      TaxDetail = Structure.new do
        # @return [String] The shipper's tax registration number associated with the shipment for customs compliance
        # purposes in certain regions.
        attribute(:tax_registration_number, String, from: "taxRegistrationNumber")

        # @return [String]
        attribute(:tax_type, String, from: "taxType")
      end
    end
  end
end
