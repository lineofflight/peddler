# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ProductFeesV0
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
