# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module Replenishment20221107
      # Use these parameters to paginate through the response.
      PaginationResponse = Structure.new do
        # @return [Integer] Total number of results matching the given filter criteria.
        attribute?(:total_results, Integer, from: "totalResults")
      end
    end
  end
end
