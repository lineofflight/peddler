# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ShippingV2
      # UnmanifestedShipmentLocation info
      UnmanifestedShipmentLocation = Structure.new do
        # @return [Address]
        attribute?(:address, Address)

        # @return [Time] Its Last Manifest Date.
        attribute?(:last_manifest_date, Time, from: "lastManifestDate")
      end
    end
  end
end
