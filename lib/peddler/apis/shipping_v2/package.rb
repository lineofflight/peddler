# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # A package to be shipped through a shipping service offering.
      Package = Structure.new do
        # @return [Dimensions]
        attribute(:dimensions, Dimensions)

        # @return [Money]
        attribute(:insured_value, Money, from: "insuredValue")

        # @return [Array<Item>]
        attribute(:items, [Item])

        # @return [String]
        attribute(:package_client_reference_id, String, from: "packageClientReferenceId")

        # @return [Weight]
        attribute(:weight, Weight)

        # @return [Array<ChargeComponent>]
        attribute?(:charges, [ChargeComponent])

        # @return [:boolean] When true, the package contains hazardous materials. Defaults to false.
        attribute?(:hazmat, :boolean, from: "isHazmat")

        # @return [String] The seller name displayed on the label.
        attribute?(:seller_display_name, String, from: "sellerDisplayName")
      end
    end
  end
end
