# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_outbound_2020_07_01/drop_off_location"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The delivery preferences applied to the destination address. These preferences are applied when possible and are
      # best effort.
      # This feature is currently supported only in the JP marketplace and not applicable for other marketplaces.
      # For eligible orders, the default delivery preference will be to deliver the package unattended at the front
      # door, unless you specify otherwise.
      DeliveryPreferences = Structure.new do
        # @return [String] Additional delivery instructions. For example, this could be instructions on how to enter a
        # building, nearby landmark or navigation instructions, 'Beware of dogs', etc.
        attribute(:delivery_instructions, String, from: "deliveryInstructions")

        # @return [DropOffLocation] The preferred location to leave packages at the destination address.
        attribute(:drop_off_location, DropOffLocation, from: "dropOffLocation")
      end
    end
  end
end
