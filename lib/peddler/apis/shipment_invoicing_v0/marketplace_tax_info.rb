# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShipmentInvoicingV0
      # Tax information about the marketplace.
      MarketplaceTaxInfo = Structure.new do
        # @return [String] The legal name of the company.
        attribute?(:company_legal_name, String, from: "CompanyLegalName")

        # @return [Array<TaxClassification>]
        attribute?(:tax_classifications, [TaxClassification], from: "TaxClassifications")

        # @return [String] The country or region imposing the tax.
        attribute?(:taxing_region, String, from: "TaxingRegion")
      end
    end
  end
end
