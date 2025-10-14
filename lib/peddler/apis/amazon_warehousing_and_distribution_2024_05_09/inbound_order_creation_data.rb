# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Payload for creating an inbound order.
      InboundOrderCreationData = Structure.new do
        # @return [Address] Origin address from where the inbound order will be shipped.
        attribute(:origin_address, Address, from: "originAddress")

        # @return [Array<DistributionPackageQuantity>] List of packages to be inbounded.
        attribute(:packages_to_inbound, [DistributionPackageQuantity], from: "packagesToInbound")

        # @return [String] Reference ID that can be used to correlate the order with partner resources.
        attribute?(:external_reference_id, String, from: "externalReferenceId")

        # @return [InboundPreferences]
        attribute?(:preferences, InboundPreferences)
      end
    end
  end
end
