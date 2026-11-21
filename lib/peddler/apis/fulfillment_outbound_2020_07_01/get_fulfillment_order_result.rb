# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20200701
      # The request for the `getFulfillmentOrder` operation.
      GetFulfillmentOrderResult = Structure.new do
        attribute(:fulfillment_order, FulfillmentOrder, null: false, from: "fulfillmentOrder")

        attribute(:fulfillment_order_items, [FulfillmentOrderItem], null: false, from: "fulfillmentOrderItems")

        attribute(:return_authorizations, [ReturnAuthorization], null: false, from: "returnAuthorizations")

        attribute(:return_items, [ReturnItem], null: false, from: "returnItems")

        attribute?(:fulfillment_shipments, [FulfillmentShipment], from: "fulfillmentShipments")

        attribute?(:payment_information, [PaymentInformation], from: "paymentInformation")
      end
    end
  end
end
