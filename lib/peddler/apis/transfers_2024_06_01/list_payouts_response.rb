# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Transfers20240601
      # The response schema for the `listPayouts` operation.
      ListPayoutsResponse = Structure.new do
        # The response includes `nextToken` when the number of results exceeds the specified page size. To get the next
        # page of results, call the operation with this token and include the same arguments as the call that produced
        # the token. To get a complete list, call this operation until `nextToken` is null. Note that this operation can
        # return empty pages.
        attribute?(:next_token, String, from: "nextToken")

        # A list of payouts matching the request criteria.
        attribute?(:payouts, [Payout])
      end
    end
  end
end
