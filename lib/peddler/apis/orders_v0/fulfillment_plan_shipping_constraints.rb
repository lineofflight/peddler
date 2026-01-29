# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # Delivery constraints applicable to this order.
      FulfillmentPlanShippingConstraints = Structure.new do
        # @return [String] Indicates if the line item needs to be delivered by pallet.
        attribute?(:pallet_delivery, String, from: "PalletDelivery")

        # @return [String] Indicates that the recipient of the line item needs to sign to confirm its delivery.
        attribute?(:signature_confirmation, String, from: "SignatureConfirmation")
      end
    end
  end
end
