# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Delivery settings for the line item.
      OrderLineItemDeliveryService = Structure.new do
        # @return [OrderLineItemPaymentOnDelivery] Payment On Delivery costs. Currently only available in India.
        attribute?(:payment_on_delivery, OrderLineItemPaymentOnDelivery, from: "paymentOnDelivery")
      end
    end
  end
end
