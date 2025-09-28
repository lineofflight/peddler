# frozen_string_literal: true

require "peddler/types/product_pricing_2022_05_01/error"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ProductPricing20220501
      # A list of error responses that are returned when a request is unsuccessful.
      class ErrorList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| Error.parse(item) }) : new
          end
        end
      end
    end
  end
end
