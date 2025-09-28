# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/excluded_benefit"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module MerchantFulfillmentV0
      # A list of excluded benefits. Refer to the `ExcludeBenefit` object for further documentation.
      class ExcludedBenefits < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| ExcludedBenefit.parse(item) }) : new
          end
        end
      end
    end
  end
end
