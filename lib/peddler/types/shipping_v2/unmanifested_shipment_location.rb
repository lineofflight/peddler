# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v2/address"

module Peddler
  module Types
    module ShippingV2
      # UnmanifestedShipmentLocation info
      UnmanifestedShipmentLocation = Structure.new do
        # @return [Address]
        attribute?(:address, Address)

        # @return [String] Its Last Manifest Date.
        attribute?(:last_manifest_date, String, from: "lastManifestDate")
      end
    end
  end
end
