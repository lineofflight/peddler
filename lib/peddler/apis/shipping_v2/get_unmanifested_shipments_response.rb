# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # The Response for the GetUnmanifestedShipmentsResponse operation.
      GetUnmanifestedShipmentsResponse = Structure.new do
        attribute?(:unmanifested_carrier_information_list, [UnmanifestedCarrierInformation], from: "unmanifestedCarrierInformationList")
      end
    end
  end
end
