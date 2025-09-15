# frozen_string_literal: true

require "peddler/types/product_pricing_v0/error"

module Peddler
  module Types
    module ProductPricingV0
      # A list of error responses returned when a request is unsuccessful.
      Errors = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the operation.
        attribute(:errors, [Error])
      end
    end
  end
end
