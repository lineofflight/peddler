# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Represents an AWD inbound order.
      InboundOrder = Structure.new do
        # @return [Time] Date when this order was created.
        attribute(:created_at, Time, from: "createdAt")

        # @return [String] Inbound order ID.
        attribute(:order_id, String, from: "orderId")

        # @return [String] Inbound order status.
        attribute(:order_status, String, from: "orderStatus")

        # @return [Address] Origin address from where the inbound order will be shipped.
        attribute(:origin_address, Address, from: "originAddress")

        # @return [Array<DistributionPackageQuantity>] List of packages to be inbounded.
        attribute(:packages_to_inbound, [DistributionPackageQuantity], from: "packagesToInbound")

        # @return [DestinationDetails] Destination details of an inbound order based on the assigned region and DC for
        #   the order.
        attribute?(:destination_details, DestinationDetails, from: "destinationDetails")

        # @return [String] Reference ID that can be used to correlate the order with partner resources.
        attribute?(:external_reference_id, String, from: "externalReferenceId")

        # @return [InboundPreferences]
        attribute?(:preferences, InboundPreferences)

        # @return [Time] Date when this order was last updated.
        attribute?(:updated_at, Time, from: "updatedAt")
      end
    end
  end
end
