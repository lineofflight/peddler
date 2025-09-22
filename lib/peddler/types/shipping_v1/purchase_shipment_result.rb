# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v1/service_rate"
require "peddler/types/shipping_v1/label_result"

module Peddler
  module Types
    module ShippingV1
      # The payload schema for the purchaseShipment operation.
      PurchaseShipmentResult = Structure.new do
        # @return [String]
        attribute(:shipment_id, String, from: "shipmentId")

        # @return [ServiceRate]
        attribute(:service_rate, ServiceRate, from: "serviceRate")

        # @return [Array<LabelResult>]
        attribute(:label_results, [LabelResult], from: "labelResults")
      end
    end
  end
end
