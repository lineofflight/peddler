# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Replenishment20221107
      # Use these parameters to paginate through the response.
      PaginationResponse = Structure.new do
        # @return [Integer] Total number of results matching the given filter criteria.
        attribute?(:total_results, Integer, from: "totalResults")
      end
    end
  end
end
