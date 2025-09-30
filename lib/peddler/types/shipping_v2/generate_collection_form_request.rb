# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v2/client_reference_detail"
require "peddler/types/shipping_v2/address"

module Peddler
  module Types
    module ShippingV2
      # The request schema Call to generate the collection form.
      GenerateCollectionFormRequest = Structure.new do
        # @return [Array<ClientReferenceDetail>]
        attribute?(:client_reference_details, [ClientReferenceDetail], from: "clientReferenceDetails")

        # @return [String]
        attribute(:carrier_id, String, from: "carrierId")

        # @return [Address]
        attribute?(:ship_from_address, Address, from: "shipFromAddress")
      end
    end
  end
end
