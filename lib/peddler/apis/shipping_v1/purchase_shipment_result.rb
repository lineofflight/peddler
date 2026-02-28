# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV1
      # The payload schema for the purchaseShipment operation.
      PurchaseShipmentResult = Structure.new do
        # @return [Array<LabelResult>]
        attribute(:label_results, [LabelResult], null: false, from: "labelResults")

        # @return [ServiceRate]
        attribute(:service_rate, ServiceRate, null: false, from: "serviceRate")

        # @return [String]
        attribute(:shipment_id, String, null: false, from: "shipmentId")
      end
    end
  end
end
