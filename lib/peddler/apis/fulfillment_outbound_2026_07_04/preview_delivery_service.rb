# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Delivery settings for a fulfillment preview.
      PreviewDeliveryService = Structure.new do
        # @return [String] Indicates whether to include payment on delivery pricing in the preview. Only present when
        #   `includePaymentOnDelivery` is `true` on the request. Possible values: `ENABLED`, `DISABLED`.
        attribute?(:payment_on_delivery, String, from: "paymentOnDelivery")
      end
    end
  end
end
