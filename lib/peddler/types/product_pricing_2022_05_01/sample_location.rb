# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/product_pricing_2022_05_01/postal_code"

module Peddler
  module Types
    module ProductPricing20220501
      # Information about a location. It uses a postal code to identify the location.
      SampleLocation = Structure.new do
        # @return [PostalCode]
        attribute?(:postal_code, PostalCode, from: "postalCode")
      end
    end
  end
end
