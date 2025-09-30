# frozen_string_literal: true

require "peddler/types/shipment_invoicing_v0/tax_classification"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShipmentInvoicingV0
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
