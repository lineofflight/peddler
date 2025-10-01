# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/product_pricing_2022_05_01/http_status_line"

module Peddler
  module Types
    module ProductPricing20220501
      # The common properties for responses to individual requests within a batch.
      BatchResponse = Structure.new do
        # @return [Hash]
        attribute(:headers, Hash)

        # @return [HttpStatusLine]
        attribute(:status, HttpStatusLine)
      end
    end
  end
end
