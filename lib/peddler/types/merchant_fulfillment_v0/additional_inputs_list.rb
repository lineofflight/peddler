# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/additional_inputs"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # A list of additional inputs.
      class AdditionalInputsList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| AdditionalInputs.parse(item) })
          end
        end
      end
    end
  end
end
