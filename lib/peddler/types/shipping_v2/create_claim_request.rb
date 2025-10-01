# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/money"
require "structure"

module Peddler
  module Types
    module ShippingV2
      # The request schema for the CreateClaim operation
      CreateClaimRequest = Structure.new do
        # @return [String]
        attribute(:claim_reason, String, from: "claimReason")

        # @return [String]
        attribute(:settlement_type, String, from: "settlementType")

        # @return [String]
        attribute(:tracking_id, String, from: "trackingId")

        # @return [Money] This is required for off-Amazon shipments to determine value of shipments
        attribute?(:declared_value, Money, from: "declaredValue")

        # @return [:boolean] Applicable for only On Amazon shipments to identify if replacement was sent
        attribute?(:replacement_package_sent, :boolean, from: "isReplacementPackageSent")

        # @return [Array<String>]
        attribute?(:proofs, [String])
      end
    end
  end
end
