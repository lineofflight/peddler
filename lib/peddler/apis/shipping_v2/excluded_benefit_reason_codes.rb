# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ShippingV2
      # List of reasons (eg. LATE_DELIVERY_RISK, etc.) indicating why a benefit is excluded for a shipping offer.
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
