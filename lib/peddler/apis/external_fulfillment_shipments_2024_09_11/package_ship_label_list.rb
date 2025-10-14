# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
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
