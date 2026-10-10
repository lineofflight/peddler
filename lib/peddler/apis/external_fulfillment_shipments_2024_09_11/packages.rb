# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # The request schema of the `createPackages` operation.
      Packages = Structure.new do
        # A list of packages.
        attribute(:packages, [Package], null: false)
      end
    end
  end
end
