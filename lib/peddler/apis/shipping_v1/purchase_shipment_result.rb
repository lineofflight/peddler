# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV1
      # The payload schema for the purchaseShipment operation.
      PurchaseShipmentResult = Structure.new do
        attribute(:label_results, [LabelResult], null: false, from: "labelResults")

        attribute(:service_rate, ServiceRate, null: false, from: "serviceRate")

        attribute(:shipment_id, String, null: false, from: "shipmentId")
      end
    end
  end
end
