# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentOrdersV1
      # The pagination elements required to retrieve the remaining data.
      Pagination = Structure.new do
        # @return [String] A generated string used to pass information to your next request. If NextToken is returned,
        # pass the value of NextToken to the next request. If NextToken is not returned, there are no more order items
        # to return.
        attribute?(:next_token, String, from: "nextToken")
      end
    end
  end
end
