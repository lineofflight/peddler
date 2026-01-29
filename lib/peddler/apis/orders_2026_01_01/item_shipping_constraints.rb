# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Special shipping requirements and restrictions that must be observed when shipping an order item.
      ItemShippingConstraints = Structure.new do
        # @return [String] Payment must be collected from the customer at the time of delivery.
        attribute?(:cash_on_delivery, String, from: "cashOnDelivery")

        # @return [String] The line item must be delivered by pallet.
        attribute?(:pallet_delivery, String, from: "palletDelivery")

        # @return [String] The carrier must confirm that the recipient is of the legal age to receive the line item upon
        #   delivery.
        attribute?(:recipient_age_verification, String, from: "recipientAgeVerification")

        # @return [String] The person receiving the line item must be the same as the intended recipient of the order.
        attribute?(:recipient_identity_verification, String, from: "recipientIdentityVerification")

        # @return [String] The recipient of the line item must sign to confirm its delivery.
        attribute?(:signature_confirmation, String, from: "signatureConfirmation")
      end
    end
  end
end
