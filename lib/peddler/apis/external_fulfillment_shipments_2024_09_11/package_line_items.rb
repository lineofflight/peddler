# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # The list of line items in a package.
      class PackageLineItems < Array
        class << self
          def parse(array)
            new(array.map { |item| PackageLineItem.parse(item) })
          end
        end
      end
    end
  end
end
