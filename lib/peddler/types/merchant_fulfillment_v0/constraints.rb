# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/constraint"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module MerchantFulfillmentV0
      # List of constraints.
      class Constraints < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| Constraint.parse(item) }) : new
          end
        end
      end
    end
  end
end
