# frozen_string_literal: true

require "peddler/types/external_fulfillment_shipments_2024_09_11/package_ship_label"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # A list of label documents for each package specified in the request. In case of partial failures when generating
      # labels, the `isErrored` and `errorDetails` attributes detail the cause of failure.
      class PackageShipLabelList < Array
        class << self
          def parse(array)
            new(array.map { |item| PackageShipLabel.parse(item) })
          end
        end
      end
    end
  end
end
