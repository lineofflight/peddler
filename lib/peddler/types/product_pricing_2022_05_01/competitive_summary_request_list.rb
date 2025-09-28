# frozen_string_literal: true

require "peddler/types/product_pricing_2022_05_01/competitive_summary_request"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ProductPricing20220501
      # A batched list of `competitiveSummary` requests.
      class CompetitiveSummaryRequestList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| CompetitiveSummaryRequest.parse(item) }) : new
          end
        end
      end
    end
  end
end
