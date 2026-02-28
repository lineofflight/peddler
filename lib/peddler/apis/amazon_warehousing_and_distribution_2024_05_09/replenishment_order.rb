# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Represents an AWD replenishment order.
      ReplenishmentOrder = Structure.new do
        # @return [String] Order Id of the replenishment order.
        attribute(:order_id, String, null: false, from: "orderId")

        # @return [Array<OutboundShipmentSummary>] List of outbound shipments that are part of this order.
        attribute(:outbound_shipments, [OutboundShipmentSummary], null: false, from: "outboundShipments")

        # @return [String]
        attribute(:status, String, null: false)

        # @return [Time] Date on which this replenishment order was confirmed.
        attribute?(:confirmed_on, Time, from: "confirmedOn")

        # @return [Time] Date on which this replenishment order was created.
        attribute?(:created_at, Time, from: "createdAt")

        # @return [Array<DistributionIneligibleReason>] Distribution errors associated with the order related to the
        #   products or packages to replenish.
        # This field will be populated if the order has products or packages which failed validation.
        attribute?(:distribution_ineligible_reasons, [DistributionIneligibleReason], from: "distributionIneligibleReasons")

        # @return [Array<DistributionProduct>] List of product units that are eligible for replenishment.
        attribute?(:eligible_products, [DistributionProduct], from: "eligibleProducts")

        # @return [Array<DistributionProduct>] Requested amount of single product units to be replenished.
        attribute?(:products, [DistributionProduct])

        # @return [Array<DistributionProduct>] Outbound product units that are shipped after the execution has completed
        #   post confirmation.
        attribute?(:shipped_products, [DistributionProduct], from: "shippedProducts")

        # @return [Time] Date on which this replenishment order was last updated.
        attribute?(:updated_at, Time, from: "updatedAt")
      end
    end
  end
end
