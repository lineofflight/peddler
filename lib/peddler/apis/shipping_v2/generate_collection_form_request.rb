# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The request schema Call to generate the collection form.
      GenerateCollectionFormRequest = Structure.new do
        # @return [String]
        attribute(:carrier_id, String, from: "carrierId")

        # @return [Array<ClientReferenceDetail>]
        attribute?(:client_reference_details, [ClientReferenceDetail], from: "clientReferenceDetails")

        # @return [Address]
        attribute?(:ship_from_address, Address, from: "shipFromAddress")
      end
    end
  end
end
