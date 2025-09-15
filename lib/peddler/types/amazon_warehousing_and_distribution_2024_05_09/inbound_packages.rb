# frozen_string_literal: true

require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/distribution_package_quantity"

module Peddler
  module Types
    module AmazonWarehousingAndDistribution20240509
      # Represents the packages to inbound.
      InboundPackages = Structure.new do
        # @return [Array<DistributionPackageQuantity>] List of packages to be inbounded.
        attribute(:packages_to_inbound, [DistributionPackageQuantity], from: "packagesToInbound")
      end
    end
  end
end
