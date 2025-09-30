# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v1/accepted_rate"
require "peddler/types/shipping_v1/label_result"

module Peddler
  module Types
    module ShippingV1
      # The payload schema for the purchaseLabels operation.
      PurchaseLabelsResult = Structure.new do
        # @return [String]
        attribute(:shipment_id, String, from: "shipmentId")

        # @return [String]
        attribute?(:client_reference_id, String, from: "clientReferenceId")

        # @return [AcceptedRate]
        attribute(:accepted_rate, AcceptedRate, from: "acceptedRate")

        # @return [Array<LabelResult>]
        attribute(:label_results, [LabelResult], from: "labelResults")
      end
    end
  end
end
