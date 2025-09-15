# frozen_string_literal: true

require "peddler/types/shipping_v2/currency"

module Peddler
  module Types
    module ShippingV2
      # The request schema for the CreateClaim operation
      CreateClaimRequest = Structure.new do
        # @return [String]
        attribute(:tracking_id, String, from: "trackingId")

        # @return [Currency] This is required for off-Amazon shipments to determine value of shipments
        attribute(:declared_value, Currency, from: "declaredValue")

        # @return [String]
        attribute(:claim_reason, String, from: "claimReason")

        # @return [:boolean] Applicable for only On Amazon shipments to identify if replacement was sent
        attribute(:is_replacement_package_sent, :boolean, from: "isReplacementPackageSent")

        # @return [Array]
        attribute(:proofs, Array)

        # @return [String]
        attribute(:settlement_type, String, from: "settlementType")
      end
    end
  end
end
