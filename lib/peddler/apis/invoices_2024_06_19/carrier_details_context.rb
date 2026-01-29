# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Invoices20240619
      # Additional information about a carrier.
      CarrierDetailsContext = Structure.new do
        # @return [String] The address of the carrier, as registered in state and federal tax authorities.
        attribute?(:address, String)

        # @return [String] Type of additional information.
        attribute?(:context_type, String, from: "contextType")

        # @return [String] Tax Identification number of the carrier.
        attribute?(:federal_tax_id, String, from: "federalTaxId")

        # @return [String] The name of the carrier, as registered in state and federal tax authorities.
        attribute?(:name, String)

        # @return [String] The code of the federal subdivision in which the carrier is registered.
        attribute?(:region_code, String, from: "regionCode")

        # @return [String] The regional tax registration number of the carrier.
        attribute?(:region_tax_id, String, from: "regionTaxId")

        # @return [String] The identifier for the carrier vehicle as printed in its registration plate.
        attribute?(:vehicle_license_plate, String, from: "vehicleLicensePlate")

        # @return [String] The code of the federal subdivision in which the carrier vehicle is registered.
        attribute?(:vehicle_registration_region_code, String, from: "vehicleRegistrationRegionCode")
      end
    end
  end
end
