# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module OrdersV0
      # Tax information about the marketplace.
      MarketplaceTaxInfo = Structure.new do
        # A list of tax classifications that apply to the order.
        attribute?(:tax_classifications, [TaxClassification], from: "TaxClassifications")
      end
    end
  end
end
