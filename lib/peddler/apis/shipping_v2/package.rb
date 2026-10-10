# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # A package to be shipped through a shipping service offering.
      Package = Structure.new do
        attribute(:dimensions, Dimensions, null: false)

        attribute(:insured_value, Money, null: false, from: "insuredValue")

        attribute(:items, [Item], null: false)

        attribute(:package_client_reference_id, String, null: false, from: "packageClientReferenceId")

        attribute(:weight, Weight, null: false)

        attribute?(:charges, [ChargeComponent])

        # When true, the package contains hazardous materials. Defaults to false.
        attribute?(:hazmat, :boolean, from: "isHazmat")

        # The seller name displayed on the label.
        attribute?(:seller_display_name, String, from: "sellerDisplayName")
      end
    end
  end
end
