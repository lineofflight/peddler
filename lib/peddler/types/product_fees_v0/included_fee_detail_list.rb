# frozen_string_literal: true

require "peddler/types/product_fees_v0/included_fee_detail"

module Peddler
  module Types
    module ProductFeesV0
      # A list of other fees that contribute to a given fee.
      class IncludedFeeDetailList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| IncludedFeeDetail.parse(item) })
          end
        end
      end
    end
  end
end
