# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module MerchantFulfillmentV0
      # List of reasons why a benefit is excluded for a shipping offer (for example, `LATE_DELIVERY_RISK`).
      class ExcludedBenefitReasonCodes < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array) : new
          end
        end
      end
    end
  end
end
