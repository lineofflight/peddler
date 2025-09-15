# frozen_string_literal: true

require "peddler/types/supply_sources_2020_07_01/duration"
require "peddler/types/supply_sources_2020_07_01/operational_configuration"
require "peddler/types/supply_sources_2020_07_01/in_store_pickup_configuration"
require "peddler/types/supply_sources_2020_07_01/curbside_pickup_configuration"

module Peddler
  module Types
    module SupplySources20200701
      # The pick up channel of a supply source.
      PickupChannel = Structure.new do
        # @return [Duration]
        attribute(:inventory_hold_period, Duration, from: "inventoryHoldPeriod")

        # @return [:boolean]
        attribute(:supported, :boolean, from: "isSupported")

        # @return [OperationalConfiguration]
        attribute(:operational_configuration, OperationalConfiguration, from: "operationalConfiguration")

        # @return [InStorePickupConfiguration] The configuration for supporting in-store pickup.
        attribute(:in_store_pickup_configuration, InStorePickupConfiguration, from: "inStorePickupConfiguration")

        # @return [CurbsidePickupConfiguration] The configuration for supporting curbside pickup.
        attribute(:curbside_pickup_configuration, CurbsidePickupConfiguration, from: "curbsidePickupConfiguration")
      end
    end
  end
end
