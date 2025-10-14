# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The request schema for the GetUnmanifestedShipmentsRequest operation.
      GetUnmanifestedShipmentsRequest = Structure.new do
        # @return [Array<ClientReferenceDetail>]
        attribute?(:client_reference_details, [ClientReferenceDetail], from: "clientReferenceDetails")
      end
    end
  end
end
