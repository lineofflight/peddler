# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The Response for the GetCarrierAccountFormInputsResponse operation.
      GetCarrierAccountFormInputsResponse = Structure.new do
        # @return [Array<LinkableCarrier>]
        attribute?(:linkable_carriers_list, [LinkableCarrier], from: "linkableCarriersList")
      end
    end
  end
end
