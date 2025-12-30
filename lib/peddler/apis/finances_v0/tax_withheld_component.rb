# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # Information about the taxes withheld.
      TaxWithheldComponent = Structure.new do
        # @return [String] The tax collection model applied to the item.
        #
        # Possible values:
        #
        # * `MarketplaceFacilitator`: Tax is withheld and remitted to the taxing authority by Amazon on behalf of the
        #   seller.
        # * `Standard`: Tax is paid to the seller and not remitted to the taxing authority by Amazon.
        attribute?(:tax_collection_model, String, from: "TaxCollectionModel")

        # @return [Array<ChargeComponent>] A list of charges that represent the types and amounts of taxes withheld.
        attribute?(:taxes_withheld, [ChargeComponent], from: "TaxesWithheld")
      end
    end
  end
end
