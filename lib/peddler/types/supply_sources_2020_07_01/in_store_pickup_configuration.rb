# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/supply_sources_2020_07_01/parking_configuration"

module Peddler
  module Types
    module SupplySources20200701
      # The in-store pickup configuration of a supply source.
      InStorePickupConfiguration = Structure.new do
        # @return [:boolean] When true, in-store pickup is supported by the supply source (default: `isSupported` value
        # in `PickupChannel`).
        attribute(:supported, :boolean, from: "isSupported")

        # @return [ParkingConfiguration] The parking configuration for in-store pickup.
        attribute(:parking_configuration, ParkingConfiguration, from: "parkingConfiguration")
      end
    end
  end
end
