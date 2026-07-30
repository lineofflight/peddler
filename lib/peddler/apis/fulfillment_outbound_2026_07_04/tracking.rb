# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Tracking information for a package.
      Tracking = Structure.new do
        # @return [AmazonTracking]
        attribute?(:amazon, AmazonTracking)

        # @return [CarrierTracking]
        attribute?(:carrier, CarrierTracking)

        # @return [OrderDropOffLocation] The drop off location for a package.
        attribute?(:drop_off_location, OrderDropOffLocation, from: "dropOffLocation")

        # @return [ProofOfDelivery] Proof of delivery information for the package.
        attribute?(:proof_of_delivery, ProofOfDelivery, from: "proofOfDelivery")
      end
    end
  end
end
