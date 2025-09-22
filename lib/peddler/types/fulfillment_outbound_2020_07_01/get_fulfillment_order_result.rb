# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_outbound_2020_07_01/fulfillment_order"
require "peddler/types/fulfillment_outbound_2020_07_01/fulfillment_order_item"
require "peddler/types/fulfillment_outbound_2020_07_01/fulfillment_shipment"
require "peddler/types/fulfillment_outbound_2020_07_01/return_item"
require "peddler/types/fulfillment_outbound_2020_07_01/return_authorization"
require "peddler/types/fulfillment_outbound_2020_07_01/payment_information"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The request for the `getFulfillmentOrder` operation.
      GetFulfillmentOrderResult = Structure.new do
        # @return [FulfillmentOrder]
        attribute(:fulfillment_order, FulfillmentOrder, from: "fulfillmentOrder")

        # @return [Array<FulfillmentOrderItem>]
        attribute(:fulfillment_order_items, [FulfillmentOrderItem], from: "fulfillmentOrderItems")

        # @return [Array<FulfillmentShipment>]
        attribute(:fulfillment_shipments, [FulfillmentShipment], from: "fulfillmentShipments")

        # @return [Array<ReturnItem>]
        attribute(:return_items, [ReturnItem], from: "returnItems")

        # @return [Array<ReturnAuthorization>]
        attribute(:return_authorizations, [ReturnAuthorization], from: "returnAuthorizations")

        # @return [Array<PaymentInformation>]
        attribute(:payment_information, [PaymentInformation], from: "paymentInformation")
      end
    end
  end
end
