# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentSandboxTestData20211028
      # A generated string used to pass information to your next request. If NextToken is returned, pass the value of
      # NextToken to the next request. If NextToken is not returned, there are no more order items to return.
      Pagination = Structure.new do
        # @return [String] A generated token to be passed in the next request to retrieve the next set of results.
        attribute?(:next_token, String, from: "nextToken")
      end
    end
  end
end
