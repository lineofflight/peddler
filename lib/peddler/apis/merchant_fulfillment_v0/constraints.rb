# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # List of constraints.
      class Constraints < Array
        class << self
          def parse(array)
            new(array.map { |item| Constraint.parse(item) })
          end
        end
      end
    end
  end
end
