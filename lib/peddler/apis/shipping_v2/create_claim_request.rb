# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # The request schema for the CreateClaim operation
      CreateClaimRequest = Structure.new do
        attribute(:claim_reason, String, null: false, from: "claimReason")

        attribute(:settlement_type, String, null: false, from: "settlementType")

        attribute(:tracking_id, String, null: false, from: "trackingId")

        # This is required for off-Amazon shipments to determine value of shipments
        attribute?(:declared_value, Money, from: "declaredValue")

        # Applicable for only On Amazon shipments to identify if replacement was sent
        attribute?(:replacement_package_sent, :boolean, from: "isReplacementPackageSent")

        attribute?(:proofs, [String])
      end
    end
  end
end
