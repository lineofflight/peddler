# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SupplySources20200701
      # The curbside pickup configuration of a supply source.
      CurbsidePickupConfiguration = Structure.new do
        # When true, curbside pickup is supported by the supply source.
        attribute?(:supported, :boolean, from: "isSupported")

        # The operational configuration for the curbside pickup configuration.
        attribute?(:operational_configuration, OperationalConfiguration, from: "operationalConfiguration")

        # The parking configuration for curbside pickup with address for customers to use.
        attribute?(:parking_with_address_configuration, ParkingWithAddressConfiguration, from: "parkingWithAddressConfiguration")
      end
    end
  end
end
