# frozen_string_literal: true

require "peddler/types/supply_sources_2020_07_01/operational_configuration"

module Peddler
  module Types
    module SupplySources20200701
      # The curbside pickup configuration of a supply source.
      CurbsidePickupConfiguration = Structure.new do
        # @return [:boolean] When true, curbside pickup is supported by the supply source.
        attribute(:supported, :boolean, from: "isSupported")

        # @return [OperationalConfiguration] The operational configuration for the curbside pickup configuration.
        attribute(:operational_configuration, OperationalConfiguration, from: "operationalConfiguration")

        # @return [Hash] The parking configuration for curbside pickup with address for customers to use.
        attribute(:parking_with_address_configuration, Hash, from: "parkingWithAddressConfiguration")
      end
    end
  end
end
