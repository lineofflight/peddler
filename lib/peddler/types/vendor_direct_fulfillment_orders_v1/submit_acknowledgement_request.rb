# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_orders_v1/order_acknowledgement_item"

module Peddler
  module Types
    module VendorDirectFulfillmentOrdersV1
      # The request schema for the submitAcknowledgement operation.
      SubmitAcknowledgementRequest = Structure.new do
        # @return [Array<OrderAcknowledgementItem>] A list of one or more purchase orders.
        attribute(:order_acknowledgements, [OrderAcknowledgementItem], from: "orderAcknowledgements")
      end
    end
  end
end
