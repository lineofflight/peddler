# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Payload for creating an outbound order.
      OutboundOrderCreationData = Structure.new do
        # @return [Array<OrderAttribute>] Order preferences for the outbound order.
        attribute?(:order_preferences, [OrderAttribute], from: "orderPreferences")

        # @return [Array<DistributionPackageQuantity>] List of packages to be outbound.
        attribute?(:packages_to_outbound, [DistributionPackageQuantity], from: "packagesToOutbound")

        # @return [Array<ProductQuantity>] List of product units to be outbound.
        attribute?(:products_to_outbound, [ProductQuantity], from: "productsToOutbound")
      end
    end
  end
end
