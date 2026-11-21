# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricing20220501
      # Information about a location. It uses a postal code to identify the location.
      SampleLocation = Structure.new do
        attribute?(:postal_code, PostalCode, from: "postalCode")
      end
    end
  end
end
