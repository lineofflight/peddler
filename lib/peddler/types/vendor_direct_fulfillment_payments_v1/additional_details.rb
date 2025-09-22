# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentPaymentsV1
      # A field where the selling party can provide additional information for tax-related or any other purposes.
      AdditionalDetails = Structure.new do
        # @return [String] The type of the additional information provided by the selling party.
        attribute(:type, String)

        # @return [String] The detail of the additional information provided by the selling party.
        attribute(:detail, String)

        # @return [String] The language code of the additional information detail.
        attribute(:language_code, String, from: "languageCode")
      end
    end
  end
end
