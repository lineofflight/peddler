# frozen_string_literal: true

module Peddler
  module Types
    module MerchantFulfillmentV0
      # The set of fixed values in an additional seller input.
      class RestrictedSetValues < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array)
          end
        end
      end
    end
  end
end
