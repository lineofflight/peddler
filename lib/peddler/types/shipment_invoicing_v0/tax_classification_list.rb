# frozen_string_literal: true

require "peddler/types/shipment_invoicing_v0/tax_classification"

module Peddler
  module Types
    module ShipmentInvoicingV0
      # The list of tax classifications.
      class TaxClassificationList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| TaxClassification.parse(item) })
          end
        end
      end
    end
  end
end
