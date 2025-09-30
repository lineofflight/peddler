# frozen_string_literal: true

require "peddler/types/product_fees_v0/fees_estimate_by_id_request"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ProductFeesV0
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
