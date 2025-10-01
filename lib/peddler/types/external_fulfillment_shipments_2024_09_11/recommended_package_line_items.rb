# frozen_string_literal: true

require "peddler/types/external_fulfillment_shipments_2024_09_11/recommended_package_line_item"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # A list of line items to be contained in a recommended package. This attribute is only for orders that come with
      # specific recommendations for line-item distribution.
      class RecommendedPackageLineItems < Array
        class << self
          def parse(array)
            new(array.map { |item| RecommendedPackageLineItem.parse(item) })
          end
        end
      end
    end
  end
end
