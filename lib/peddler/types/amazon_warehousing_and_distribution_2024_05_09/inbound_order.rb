# frozen_string_literal: true

require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/destination_details"
require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/address"
require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/distribution_package_quantity"
require "peddler/types/amazon_warehousing_and_distribution_2024_05_09/inbound_preferences"

module Peddler
  module Types
    module AmazonWarehousingAndDistribution20240509
      # Represents an AWD inbound order.
      InboundOrder = Structure.new do
        # @return [String] Date when this order was created.
        attribute(:created_at, String, from: "createdAt")

        # @return [DestinationDetails] Destination details of an inbound order based on the assigned region and DC for
        # the order.
        attribute(:destination_details, DestinationDetails, from: "destinationDetails")

        # @return [String] Reference ID that can be used to correlate the order with partner resources.
        attribute(:external_reference_id, String, from: "externalReferenceId")

        # @return [String] Inbound order ID.
        attribute(:order_id, String, from: "orderId")

        # @return [String] Inbound order status.
        attribute(:order_status, String, from: "orderStatus")

        # @return [Address] Origin address from where the inbound order will be shipped.
        attribute(:origin_address, Address, from: "originAddress")

        # @return [Array<DistributionPackageQuantity>] List of packages to be inbounded.
        attribute(:packages_to_inbound, [DistributionPackageQuantity], from: "packagesToInbound")

        # @return [InboundPreferences]
        attribute(:preferences, InboundPreferences)

        # @return [String] Date when this order was last updated.
        attribute(:updated_at, String, from: "updatedAt")
      end
    end
  end
end
