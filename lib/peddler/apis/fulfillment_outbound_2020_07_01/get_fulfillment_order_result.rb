# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The request for the `getFulfillmentOrder` operation.
      GetFulfillmentOrderResult = Structure.new do
        # @return [FulfillmentOrder]
        attribute(:fulfillment_order, FulfillmentOrder, from: "fulfillmentOrder")

        # @return [Array<FulfillmentOrderItem>]
        attribute(:fulfillment_order_items, [FulfillmentOrderItem], from: "fulfillmentOrderItems")

        # @return [Array<ReturnAuthorization>]
        attribute(:return_authorizations, [ReturnAuthorization], from: "returnAuthorizations")

        # @return [Array<ReturnItem>]
        attribute(:return_items, [ReturnItem], from: "returnItems")

        # @return [Array<FulfillmentShipment>]
        attribute?(:fulfillment_shipments, [FulfillmentShipment], from: "fulfillmentShipments")

        # @return [Array<PaymentInformation>]
        attribute?(:payment_information, [PaymentInformation], from: "paymentInformation")
      end
    end
  end
end
