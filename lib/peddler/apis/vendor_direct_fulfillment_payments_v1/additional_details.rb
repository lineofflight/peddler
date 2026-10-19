# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentPaymentsV1
      # A field where the selling party can provide additional information for tax-related or any other purposes.
      AdditionalDetails = Structure.new do
        # The detail of the additional information provided by the selling party.
        attribute(:detail, String, null: false)

        # The type of the additional information provided by the selling party. Known values: `SUR`, `OCR`,
        # `TaxExemptReason`, `LegalTerms`, `RegulatoryNote`.
        attribute(:type, String, null: false)

        # The language code of the additional information detail.
        attribute?(:language_code, String, from: "languageCode")
      end
    end
  end
end
