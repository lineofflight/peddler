# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ProductFeesV0
      # Request for estimated fees for a list of products.
      class GetMyFeesEstimatesRequest < Array
        class << self
          def parse(array)
            new(array.map { |item| FeesEstimateByIdRequest.parse(item) })
          end
        end
      end
    end
  end
end
