# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/orders_v0/tax_classification"

module Peddler
  module Types
    module OrdersV0
      # Tax information about the buyer.
      BuyerTaxInfo = Structure.new do
        # @return [String] The legal name of the company.
        attribute(:company_legal_name, String, from: "CompanyLegalName")

        # @return [String] The country or region imposing the tax.
        attribute(:taxing_region, String, from: "TaxingRegion")

        # @return [Array<TaxClassification>] A list of tax classifications that apply to the order.
        attribute(:tax_classifications, [TaxClassification], from: "TaxClassifications")
      end
    end
  end
end
