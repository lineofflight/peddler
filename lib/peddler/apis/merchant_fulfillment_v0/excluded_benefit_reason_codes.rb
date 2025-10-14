# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # List of reasons why a benefit is excluded for a shipping offer (for example, `LATE_DELIVERY_RISK`).
      class ExcludedBenefitReasonCodes < Array
        class << self
          def parse(array)
            new(array)
          end
        end
      end
    end
  end
end
