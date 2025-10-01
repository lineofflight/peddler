# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/money"
require "peddler/types/shipping_v2/dimensions"
require "peddler/types/shipping_v2/item"
require "peddler/types/shipping_v2/weight"
require "peddler/types/shipping_v2/charge_component"

module Peddler
  module Types
    module ShippingV2
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
