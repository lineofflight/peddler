# frozen_string_literal: true

require "peddler/types/product_pricing_v0/error"

module Peddler
  module Types
    module ProductPricingV0
      # A list of error responses returned when a request is unsuccessful.
      class ErrorList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| Error.parse(item) })
          end
        end
      end
    end
  end
end
