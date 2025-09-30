# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Filter for use when requesting eligible shipping services.
      ShippingOfferingFilter = Structure.new do
        # @return [:boolean] When true, include a packing slip with the label.
        attribute?(:include_packing_slip_with_label, :boolean, from: "IncludePackingSlipWithLabel")

        # @return [:boolean] When true, include complex shipping options.
        attribute?(:include_complex_shipping_options, :boolean, from: "IncludeComplexShippingOptions")

        # @return [String]
        attribute?(:carrier_will_pick_up, String, from: "CarrierWillPickUp")

        # @return [String]
        attribute?(:delivery_experience, String, from: "DeliveryExperience")
      end
    end
  end
end
