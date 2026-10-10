# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV1
      # The payload schema for the purchaseLabels operation.
      PurchaseLabelsResult = Structure.new do
        attribute(:accepted_rate, AcceptedRate, null: false, from: "acceptedRate")

        attribute(:label_results, [LabelResult], null: false, from: "labelResults")

        attribute(:shipment_id, String, null: false, from: "shipmentId")

        attribute?(:client_reference_id, String, from: "clientReferenceId")
      end
    end
  end
end
