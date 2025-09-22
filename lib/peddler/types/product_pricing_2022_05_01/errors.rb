# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/product_pricing_2022_05_01/error"

module Peddler
  module Types
    module ProductPricing20220501
      # A list of error responses returned when a request is unsuccessful.
      Errors = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the operation.
        attribute(:errors, [Error])
      end
    end
  end
end
