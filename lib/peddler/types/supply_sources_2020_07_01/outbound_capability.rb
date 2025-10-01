# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/supply_sources_2020_07_01/delivery_channel"
require "peddler/types/supply_sources_2020_07_01/operational_configuration"
require "peddler/types/supply_sources_2020_07_01/pickup_channel"
require "peddler/types/supply_sources_2020_07_01/return_location"

module Peddler
  module Types
    module SupplySources20200701
      # The outbound capability of a supply source.
      OutboundCapability = Structure.new do
        # @return [DeliveryChannel]
        attribute?(:delivery_channel, DeliveryChannel, from: "deliveryChannel")

        # @return [:boolean]
        attribute?(:supported, :boolean, from: "isSupported")

        # @return [OperationalConfiguration]
        attribute?(:operational_configuration, OperationalConfiguration, from: "operationalConfiguration")

        # @return [PickupChannel]
        attribute?(:pickup_channel, PickupChannel, from: "pickupChannel")

        # @return [ReturnLocation]
        attribute?(:return_location, ReturnLocation, from: "returnLocation")
      end
    end
  end
end
