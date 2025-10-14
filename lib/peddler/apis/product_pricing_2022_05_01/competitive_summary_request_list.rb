# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ProductPricing20220501
      # A batched list of `competitiveSummary` requests.
      class CompetitiveSummaryRequestList < Array
        class << self
          def parse(array)
            new(array.map { |item| CompetitiveSummaryRequest.parse(item) })
          end
        end
      end
    end
  end
end
