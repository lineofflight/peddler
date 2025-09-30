# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/temporarily_unavailable_carrier"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module MerchantFulfillmentV0
      # A list of temporarily unavailable carriers.
      class TemporarilyUnavailableCarrierList < Array
        class << self
          def parse(array)
            new(array.map { |item| TemporarilyUnavailableCarrier.parse(item) })
          end
        end
      end
    end
  end
end
