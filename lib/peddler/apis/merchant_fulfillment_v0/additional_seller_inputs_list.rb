# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # A list of additional seller input pairs required to purchase shipping.
      class AdditionalSellerInputsList < Array
        class << self
          def parse(array)
            new(array.map { |item| AdditionalSellerInputs.parse(item) })
          end
        end
      end
    end
  end
end
