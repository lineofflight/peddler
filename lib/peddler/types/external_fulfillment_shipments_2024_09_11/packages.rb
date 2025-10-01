# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_shipments_2024_09_11/package"

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # The request schema of the `createPackages` operation.
      Packages = Structure.new do
        # @return [Array<Package>] A list of packages.
        attribute(:packages, [Package])
      end
    end
  end
end
