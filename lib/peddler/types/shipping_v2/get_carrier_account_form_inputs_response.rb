# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v2/linkable_carrier"

module Peddler
  module Types
    module ShippingV2
      # The Response for the GetCarrierAccountFormInputsResponse operation.
      GetCarrierAccountFormInputsResponse = Structure.new do
        # @return [Array<LinkableCarrier>]
        attribute?(:linkable_carriers_list, [LinkableCarrier], from: "linkableCarriersList")
      end
    end
  end
end
