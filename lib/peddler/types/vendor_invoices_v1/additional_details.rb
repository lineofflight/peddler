# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module VendorInvoicesV1
      # Additional information provided by the selling party for tax-related or any other purpose.
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
