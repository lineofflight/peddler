# frozen_string_literal: true

module Peddler
  module Types
    module ShippingV2
      # List of reasons (eg. LATE_DELIVERY_RISK, etc.) indicating why a benefit is excluded for a shipping offer.
      class ExcludedBenefitReasonCodes < Array
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
