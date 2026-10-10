# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AmazonWarehousingAndDistribution20240509
      # Payload for creating an inbound order.
      InboundOrderCreationData = Structure.new do
        # Origin address from where the inbound order will be shipped.
        attribute(:origin_address, Address, null: false, from: "originAddress")

        # List of packages to be inbounded.
        attribute(:packages_to_inbound, [DistributionPackageQuantity], null: false, from: "packagesToInbound")

        # Reference ID that can be used to correlate the order with partner resources.
        attribute?(:external_reference_id, String, from: "externalReferenceId")

        attribute?(:preferences, InboundPreferences)
      end
    end
  end
end
