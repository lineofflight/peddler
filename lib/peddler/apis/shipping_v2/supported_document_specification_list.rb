# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ShippingV2
      # A list of the document specifications supported for a shipment service offering.
      class SupportedDocumentSpecificationList < Array
        class << self
          def parse(array)
            new(array.map { |item| SupportedDocumentSpecification.parse(item) })
          end
        end
      end
    end
  end
end
