# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # The request schema of the `createPackages` operation.
      Packages = Structure.new do
        # @return [Array<Package>] A list of packages.
        attribute(:packages, [Package])
      end
    end
  end
end
