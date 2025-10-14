# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Information used to determine the tax compliance.
      TaxDetails = Structure.new do
        # @return [Money]
        attribute?(:declared_value, Money, from: "declaredValue")

        # @return [String] Harmonized System of Nomenclature code.
        attribute?(:hsn_code, String, from: "hsnCode")

        # @return [Array<TaxRate>] List of tax rates.
        attribute?(:tax_rates, [TaxRate], from: "taxRates")
      end
    end
  end
end
