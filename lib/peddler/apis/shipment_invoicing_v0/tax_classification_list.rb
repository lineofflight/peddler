# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ShipmentInvoicingV0
      # The list of tax classifications.
      class TaxClassificationList < Array
        class << self
          def parse(array)
            new(array.map { |item| TaxClassification.parse(item) })
          end
        end
      end
    end
  end
end
