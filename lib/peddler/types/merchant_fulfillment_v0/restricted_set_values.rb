# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module MerchantFulfillmentV0
      # The set of fixed values in an additional seller input.
      class RestrictedSetValues < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array) : new
          end
        end
      end
    end
  end
end
