# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/constraint"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # List of constraints.
      class Constraints < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| Constraint.parse(item) })
          end
        end
      end
    end
  end
end
