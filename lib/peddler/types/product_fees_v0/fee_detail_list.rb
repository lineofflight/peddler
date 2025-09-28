# frozen_string_literal: true

require "peddler/types/product_fees_v0/fee_detail"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ProductFeesV0
      # A list of other fees that contribute to a given fee.
      class FeeDetailList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| FeeDetail.parse(item) }) : new
          end
        end
      end
    end
  end
end
