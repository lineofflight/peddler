# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module AmazonWarehousingAndDistribution20240509
      # Represents an AWD inbound order.
      InboundOrder = Structure.new do
        # Date when this order was created.
        attribute(:created_at, Time, null: false, from: "createdAt")

        # Inbound order ID.
        attribute(:order_id, String, null: false, from: "orderId")

        # Inbound order status. Known values: `DRAFT`, `VALIDATING`, `CONFIRMED`, `CLOSED`, `EXPIRED`, `CANCELLED`.
        attribute(:order_status, String, null: false, from: "orderStatus")

        # Origin address from where the inbound order will be shipped.
        attribute(:origin_address, Address, null: false, from: "originAddress")

        # List of packages to be inbounded.
        attribute(:packages_to_inbound, [DistributionPackageQuantity], null: false, from: "packagesToInbound")

        # Destination details of an inbound order based on the assigned region and DC for the order.
        attribute?(:destination_details, DestinationDetails, from: "destinationDetails")

        # Reference ID that can be used to correlate the order with partner resources.
        attribute?(:external_reference_id, String, from: "externalReferenceId")

        attribute?(:preferences, InboundPreferences)

        # Date when this order was last updated.
        attribute?(:updated_at, Time, from: "updatedAt")
      end
    end
  end
end
