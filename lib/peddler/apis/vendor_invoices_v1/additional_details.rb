# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorInvoicesV1
      # Additional information provided by the selling party for tax-related or any other purpose.
      AdditionalDetails = Structure.new do
        # @return [String] The detail of the additional information provided by the selling party.
        attribute(:detail, String, null: false)

        # @return [String] The type of the additional information provided by the selling party.
        attribute(:type, String, null: false)

        # @return [String] The language code of the additional information detail.
        attribute?(:language_code, String, from: "languageCode")
      end
    end
  end
end
