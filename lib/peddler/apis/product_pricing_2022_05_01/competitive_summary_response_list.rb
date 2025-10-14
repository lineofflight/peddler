# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ProductPricing20220501
      # The response list for the `competitiveSummaryBatch` operation.
      class CompetitiveSummaryResponseList < Array
        class << self
          def parse(array)
            new(array.map { |item| CompetitiveSummaryResponse.parse(item) })
          end
        end
      end
    end
  end
end
