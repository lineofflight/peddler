# frozen_string_literal: true

module Peddler
  module Types
    module MerchantFulfillmentV0
      # A list of transparency codes.
      class TransparencyCodeList < Array
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
