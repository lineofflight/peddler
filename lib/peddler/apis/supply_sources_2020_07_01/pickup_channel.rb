# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SupplySources20200701
      # The pick up channel of a supply source.
      PickupChannel = Structure.new do
        # @return [CurbsidePickupConfiguration] The configuration for supporting curbside pickup.
        attribute?(:curbside_pickup_configuration, CurbsidePickupConfiguration, from: "curbsidePickupConfiguration")

        # @return [InStorePickupConfiguration] The configuration for supporting in-store pickup.
        attribute?(:in_store_pickup_configuration, InStorePickupConfiguration, from: "inStorePickupConfiguration")

        # @return [Duration]
        attribute?(:inventory_hold_period, Duration, from: "inventoryHoldPeriod")

        # @return [:boolean]
        attribute?(:supported, :boolean, from: "isSupported")

        # @return [OperationalConfiguration]
        attribute?(:operational_configuration, OperationalConfiguration, from: "operationalConfiguration")
      end
    end
  end
end
