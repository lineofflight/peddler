# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricing20220501
      # Postal code value with country code
      PostalCode = Structure.new do
        # Country code value
        attribute?(:country_code, String, from: "countryCode")

        # Postal code value
        attribute?(:value, String)
      end
    end
  end
end
