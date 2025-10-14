# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SupplySources20200701
      # The curbside pickup configuration of a supply source.
      CurbsidePickupConfiguration = Structure.new do
        # @return [:boolean] When true, curbside pickup is supported by the supply source.
        attribute?(:supported, :boolean, from: "isSupported")

        # @return [OperationalConfiguration] The operational configuration for the curbside pickup configuration.
        attribute?(:operational_configuration, OperationalConfiguration, from: "operationalConfiguration")

        # @return [ParkingWithAddressConfiguration] The parking configuration for curbside pickup with address for
        # customers to use.
        attribute?(:parking_with_address_configuration, ParkingWithAddressConfiguration, from: "parkingWithAddressConfiguration")
      end
    end
  end
end
