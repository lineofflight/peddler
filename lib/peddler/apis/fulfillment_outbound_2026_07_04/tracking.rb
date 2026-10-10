# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20260704
      # Tracking information for a package.
      Tracking = Structure.new do
        attribute?(:amazon, AmazonTracking)

        attribute?(:carrier, CarrierTracking)

        # The drop off location for a package.
        attribute?(:drop_off_location, OrderDropOffLocation, from: "dropOffLocation")

        # Proof of delivery information for the package.
        attribute?(:proof_of_delivery, ProofOfDelivery, from: "proofOfDelivery")
      end
    end
  end
end
