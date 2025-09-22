# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ProductPricing20220501
      # Postal code value with country code
      PostalCode = Structure.new do
        # @return [String] Country code value
        attribute(:country_code, String, from: "countryCode")

        # @return [String] Postal code value
        attribute(:value, String)
      end
    end
  end
end
