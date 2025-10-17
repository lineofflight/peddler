# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentReturns20240911
      # The response to the `listReturns` operation.
      ReturnsResponse = Structure.new do
        # @return [String] A token that you use to retrieve the next page of results. The response includes `nextToken`
        #   when there are multiple pages of results. To get the next page of results, call the operation with this
        #   token and include the same arguments as the call that produced the token. To get a complete list, call this
        #   operation until `nextToken` is null. Note that this operation can return empty pages.
        attribute?(:next_token, String, from: "nextToken")

        # @return [Array<Return>] A list of returns.
        attribute?(:returns, [Return])
      end
    end
  end
end
