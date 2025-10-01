# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v1/label_result"
require "peddler/types/shipping_v1/service_rate"

module Peddler
  module Types
    module ShippingV1
      # The payload schema for the purchaseShipment operation.
      PurchaseShipmentResult = Structure.new do
        # @return [Array<LabelResult>]
        attribute(:label_results, [LabelResult], from: "labelResults")

        # @return [ServiceRate]
        attribute(:service_rate, ServiceRate, from: "serviceRate")

        # @return [String]
        attribute(:shipment_id, String, from: "shipmentId")
      end
    end
  end
end
