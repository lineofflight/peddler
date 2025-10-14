# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV1
      # The payload schema for the purchaseLabels operation.
      PurchaseLabelsResult = Structure.new do
        # @return [AcceptedRate]
        attribute(:accepted_rate, AcceptedRate, from: "acceptedRate")

        # @return [Array<LabelResult>]
        attribute(:label_results, [LabelResult], from: "labelResults")

        # @return [String]
        attribute(:shipment_id, String, from: "shipmentId")

        # @return [String]
        attribute?(:client_reference_id, String, from: "clientReferenceId")
      end
    end
  end
end
