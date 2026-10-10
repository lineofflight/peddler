# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # Filter for use when requesting eligible shipping services.
      ShippingOfferingFilter = Structure.new do
        attribute?(:carrier_will_pick_up, String, from: "CarrierWillPickUp")

        attribute?(:delivery_experience, String, from: "DeliveryExperience")

        # When true, include complex shipping options.
        attribute?(:include_complex_shipping_options, :boolean, from: "IncludeComplexShippingOptions")

        # When true, include a packing slip with the label.
        attribute?(:include_packing_slip_with_label, :boolean, from: "IncludePackingSlipWithLabel")
      end
    end
  end
end
