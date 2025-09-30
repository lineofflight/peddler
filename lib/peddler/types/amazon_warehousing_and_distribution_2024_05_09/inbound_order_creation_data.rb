# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/address"
require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/distribution_package_quantity"
require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/inbound_preferences"

module Peddler
  module Types
    module AmazonWarehousingAndDistribution20240509
      # Payload for creating an inbound order.
      InboundOrderCreationData = Structure.new do
        # @return [String] Reference ID that can be used to correlate the order with partner resources.
        attribute?(:external_reference_id, String, from: "externalReferenceId")

        # @return [Address] Origin address from where the inbound order will be shipped.
        attribute(:origin_address, Address, from: "originAddress")

        # @return [Array<DistributionPackageQuantity>] List of packages to be inbounded.
        attribute(:packages_to_inbound, [DistributionPackageQuantity], from: "packagesToInbound")

        # @return [InboundPreferences]
        attribute?(:preferences, InboundPreferences)
      end
    end
  end
end
