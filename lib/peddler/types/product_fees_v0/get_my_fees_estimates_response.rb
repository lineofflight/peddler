# frozen_string_literal: true

require "peddler/types/product_fees_v0/fees_estimate_result"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ProductFeesV0
      # Estimated fees for a list of products.
      class GetMyFeesEstimatesResponse < Array
        class << self
          def parse(array)
            new(array.map { |item| FeesEstimateResult.parse(item) })
          end
        end
      end
    end
  end
end
