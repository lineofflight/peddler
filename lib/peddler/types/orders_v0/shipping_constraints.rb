# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module OrdersV0
      # Delivery constraints applicable to this order.
      ShippingConstraints = Structure.new do
        # @return [String] Indicates if the line item needs to be delivered by pallet.
        attribute?(:pallet_delivery, String, from: "PalletDelivery")

        # @return [String] Indicates that the carrier must confirm the recipient is of the legal age to receive the line
        # item upon delivery.
        attribute?(:recipient_age_verification, String, from: "RecipientAgeVerification")

        # @return [String] Indicates that the person receiving the line item must be the same as the intended recipient
        # of the order.
        attribute?(:recipient_identity_verification, String, from: "RecipientIdentityVerification")

        # @return [String] Indicates that the recipient of the line item must sign to confirm its delivery.
        attribute?(:signature_confirmation, String, from: "SignatureConfirmation")
      end
    end
  end
end
