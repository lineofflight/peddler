# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/terms_and_conditions_not_accepted_carrier"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # List of carriers whose terms and conditions were not accepted by the seller.
      class TermsAndConditionsNotAcceptedCarrierList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| TermsAndConditionsNotAcceptedCarrier.parse(item) })
          end
        end
      end
    end
  end
end
