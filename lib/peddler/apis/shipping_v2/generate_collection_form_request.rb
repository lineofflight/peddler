# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # The request schema Call to generate the collection form.
      GenerateCollectionFormRequest = Structure.new do
        attribute(:carrier_id, String, null: false, from: "carrierId")

        attribute?(:client_reference_details, [ClientReferenceDetail], from: "clientReferenceDetails")

        attribute?(:ship_from_address, Address, from: "shipFromAddress")
      end
    end
  end
end
