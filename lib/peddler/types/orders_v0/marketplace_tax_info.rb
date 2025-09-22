# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/orders_v0/tax_classification"

module Peddler
  module Types
    module OrdersV0
      # Tax information about the marketplace.
      MarketplaceTaxInfo = Structure.new do
        # @return [Array<TaxClassification>] A list of tax classifications that apply to the order.
        attribute(:tax_classifications, [TaxClassification], from: "TaxClassifications")
      end
    end
  end
end
