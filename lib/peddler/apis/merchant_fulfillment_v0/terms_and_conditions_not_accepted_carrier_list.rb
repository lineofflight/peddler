# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # List of carriers whose terms and conditions were not accepted by the seller.
      class TermsAndConditionsNotAcceptedCarrierList < Array
        class << self
          def parse(array)
            new(array.map { |item| TermsAndConditionsNotAcceptedCarrier.parse(item) })
          end
        end
      end
    end
  end
end
