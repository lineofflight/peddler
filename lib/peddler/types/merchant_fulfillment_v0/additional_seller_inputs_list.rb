# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/additional_seller_inputs"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module MerchantFulfillmentV0
      # A list of additional seller input pairs required to purchase shipping.
      class AdditionalSellerInputsList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| AdditionalSellerInputs.parse(item) }) : new
          end
        end
      end
    end
  end
end
