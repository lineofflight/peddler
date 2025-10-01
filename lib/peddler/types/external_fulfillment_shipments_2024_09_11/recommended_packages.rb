# frozen_string_literal: true

require "peddler/types/external_fulfillment_shipments_2024_09_11/recommended_package"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # Recommendations for the packages in an order.
      class RecommendedPackages < Array
        class << self
          def parse(array)
            new(array.map { |item| RecommendedPackage.parse(item) })
          end
        end
      end
    end
  end
end
