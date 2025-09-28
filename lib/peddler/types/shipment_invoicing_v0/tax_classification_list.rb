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
            array.is_a?(Array) ? new(array.map { |item| TaxClassification.parse(item) }) : new
          end
        end
      end
    end
  end
end
