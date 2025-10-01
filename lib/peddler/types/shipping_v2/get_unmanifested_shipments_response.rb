# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v2/unmanifested_carrier_information"

module Peddler
  module Types
    module ShippingV2
      # The Response for the GetUnmanifestedShipmentsResponse operation.
      GetUnmanifestedShipmentsResponse = Structure.new do
        # @return [Array<UnmanifestedCarrierInformation>]
        attribute?(:unmanifested_carrier_information_list, [UnmanifestedCarrierInformation], from: "unmanifestedCarrierInformationList")
      end
    end
  end
end
