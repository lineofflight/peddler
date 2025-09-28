# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV2
      # List of reasons (eg. LATE_DELIVERY_RISK, etc.) indicating why a benefit is excluded for a shipping offer.
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
