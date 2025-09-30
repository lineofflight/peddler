# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_orders_2021_12_28/order_acknowledgement_item"

module Peddler
  module Types
    module VendorDirectFulfillmentOrders20211228
      # The request schema for the submitAcknowledgement operation.
      SubmitAcknowledgementRequest = Structure.new do
        # @return [Array<OrderAcknowledgementItem>] A list of one or more purchase orders.
        attribute?(:order_acknowledgements, [OrderAcknowledgementItem], from: "orderAcknowledgements")
      end
    end
  end
end
