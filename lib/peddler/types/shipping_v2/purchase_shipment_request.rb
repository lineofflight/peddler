# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v2/requested_document_specification"
require "peddler/types/shipping_v2/requested_value_added_service"

module Peddler
  module Types
    module ShippingV2
      # The request schema for the purchaseShipment operation.
      PurchaseShipmentRequest = Structure.new do
        # @return [String]
        attribute(:request_token, String, from: "requestToken")

        # @return [String]
        attribute(:rate_id, String, from: "rateId")

        # @return [RequestedDocumentSpecification]
        attribute(:requested_document_specification, RequestedDocumentSpecification, from: "requestedDocumentSpecification")

        # @return [Array<RequestedValueAddedService>]
        attribute?(:requested_value_added_services, [RequestedValueAddedService], from: "requestedValueAddedServices")

        # @return [Hash] The additional inputs required to purchase a shipping offering, in JSON format. The JSON
        # provided here must adhere to the JSON schema that is returned in the response to the getAdditionalInputs
        # operation.
        #
        # Additional inputs are only required when indicated by the requiresAdditionalInputs property in the response to
        # the getRates operation.
        attribute?(:additional_inputs, Hash, from: "additionalInputs")
      end
    end
  end
end
