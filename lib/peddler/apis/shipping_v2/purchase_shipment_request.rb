# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # The request schema for the purchaseShipment operation.
      PurchaseShipmentRequest = Structure.new do
        attribute(:rate_id, String, null: false, from: "rateId")

        attribute(:request_token, String, null: false, from: "requestToken")

        attribute(:requested_document_specification, RequestedDocumentSpecification, null: false, from: "requestedDocumentSpecification")

        # The additional inputs required to purchase a shipping offering, in JSON format. The JSON provided here must
        # adhere to the JSON schema that is returned in the response to the getAdditionalInputs operation.
        #
        # Additional inputs are only required when indicated by the requiresAdditionalInputs property in the response to
        # the getRates operation.
        attribute?(:additional_inputs, Hash, from: "additionalInputs")

        attribute?(:requested_value_added_services, [RequestedValueAddedService], from: "requestedValueAddedServices")
      end
    end
  end
end
