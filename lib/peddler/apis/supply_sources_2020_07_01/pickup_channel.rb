# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SupplySources20200701
      # The pick up channel of a supply source.
      PickupChannel = Structure.new do
        # The configuration for supporting curbside pickup.
        attribute?(:curbside_pickup_configuration, CurbsidePickupConfiguration, from: "curbsidePickupConfiguration")

        # The configuration for supporting in-store pickup.
        attribute?(:in_store_pickup_configuration, InStorePickupConfiguration, from: "inStorePickupConfiguration")

        attribute?(:inventory_hold_period, Duration, from: "inventoryHoldPeriod")

        attribute?(:supported, :boolean, from: "isSupported")

        attribute?(:operational_configuration, OperationalConfiguration, from: "operationalConfiguration")
      end
    end
  end
end
