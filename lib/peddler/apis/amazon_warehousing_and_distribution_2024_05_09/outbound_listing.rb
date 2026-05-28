# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # A list of paginated outbound orders filtered by the attributes passed in the request.
      OutboundListing = Structure.new do
        # @return [String] TA token that is used to retrieve the next page of results. The response includes `nextToken`
        #   when the number of results exceeds the specified `maxResults` value. To get the next page of results, call
        #   the operation with this token and include the same arguments as the call that produced the token. To get a
        #   complete list, call this operation until `nextToken` is null. Note that this operation can return empty
        #   pages.
        attribute?(:next_token, String, from: "nextToken")

        # @return [Array<OutboundOrder>] List of outbound orders.
        attribute?(:outbound_orders, [OutboundOrder], from: "outboundOrders")
      end
    end
  end
end
