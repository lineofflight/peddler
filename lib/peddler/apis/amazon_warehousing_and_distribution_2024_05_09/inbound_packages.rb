# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AmazonWarehousingAndDistribution20240509
      # Represents the packages to inbound.
      InboundPackages = Structure.new do
        # List of packages to be inbounded.
        attribute(:packages_to_inbound, [DistributionPackageQuantity], null: false, from: "packagesToInbound")
      end
    end
  end
end
