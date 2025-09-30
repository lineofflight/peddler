# frozen_string_literal: true

require "peddler/types/product_pricing_2022_05_01/competitive_summary_response"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ProductPricing20220501
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
