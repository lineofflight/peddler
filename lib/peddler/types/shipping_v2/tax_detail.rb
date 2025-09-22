# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # Indicates the tax specifications associated with the shipment for customs compliance purposes in certain
      # regions.
      TaxDetail = Structure.new do
        # @return [String]
        attribute(:tax_type, String, from: "taxType")

        # @return [String] The shipper's tax registration number associated with the shipment for customs compliance
        # purposes in certain regions.
        attribute(:tax_registration_number, String, from: "taxRegistrationNumber")
      end
    end
  end
end
