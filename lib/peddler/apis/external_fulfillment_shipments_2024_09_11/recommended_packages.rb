# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
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
