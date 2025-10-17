# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FBAInventoryV1
      # The process of returning the results to a request in batches of a defined size called pages. This is done to
      # exercise some control over result size and overall throughput. It's a form of traffic management.
      Pagination = Structure.new do
        # @return [String] A generated string used to retrieve the next page of the result. If nextToken is returned,
        #   pass the value of nextToken to the next request. If nextToken is not returned, there are no more items to
        #   return.
        attribute?(:next_token, String, from: "nextToken")
      end
    end
  end
end
