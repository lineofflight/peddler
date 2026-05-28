# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Represents an AWD outbound order.
      OutboundOrder = Structure.new do
        # @return [String] Order ID for the outbound order.
        attribute(:order_id, String, null: false, from: "orderId")

        # @return [String] Status for the outbound order.
        attribute(:order_status, String, null: false, from: "orderStatus")

        # @return [Array<OutboundShipment>] List of outbound shipments that are part of this order.
        attribute(:outbound_shipments, [OutboundShipment], null: false, from: "outboundShipments")

        # @return [Time] Date on which this outbound order was confirmed.
        attribute?(:confirmed_on, Time, from: "confirmedOn")

        # @return [Time] Date on which this outbound order was created.
        attribute?(:created_at, Time, from: "createdAt")

        # @return [Array<DistributionPackageQuantity>] List of packages that are eligible for outbound.
        attribute?(:eligible_packages_to_outbound, [DistributionPackageQuantity], from: "eligiblePackagesToOutbound")

        # @return [Array<ProductQuantity>] List of product units that are eligible for outbound.
        attribute?(:eligible_products_to_outbound, [ProductQuantity], from: "eligibleProductsToOutbound")

        # @return [Array<OutboundExecutionError>] Execution errors associated with the outbound order. This field will
        #   be populated if the order failed validation.
        attribute?(:execution_errors, [OutboundExecutionError], from: "executionErrors")

        # @return [Array<OrderAttribute>] Order preferences for this outbound order.
        attribute?(:order_preferences, [OrderAttribute], from: "orderPreferences")

        # @return [Array<DistributionPackageQuantity>] List of packages to be outbound.
        attribute?(:packages_to_outbound, [DistributionPackageQuantity], from: "packagesToOutbound")

        # @return [Array<ProductQuantity>] List of product units to be outbound.
        attribute?(:products_to_outbound, [ProductQuantity], from: "productsToOutbound")

        # @return [Array<DistributionPackageQuantity>] Outbound packages that are shipped after the execution has
        #   completed post confirmation.
        attribute?(:shipped_outbound_packages, [DistributionPackageQuantity], from: "shippedOutboundPackages")

        # @return [Array<ProductQuantity>] Outbound product units that are shipped after the execution has completed
        #   post confirmation.
        attribute?(:shipped_outbound_products, [ProductQuantity], from: "shippedOutboundProducts")

        # @return [Time] Date on which this outbound order was last updated.
        attribute?(:updated_at, Time, from: "updatedAt")
      end
    end
  end
end
