# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The estimated shipping cost associated with the transportation option.
      Quote = Structure.new do
        # @return [Types::Money]
        attribute(:cost, Types::Money)

        # @return [String] The time at which this transportation option quote expires. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime with pattern
        # `yyyy-MM-ddTHH:mm:ss.sssZ`.
        attribute(:expiration, String)

        # @return [String] Voidable until timestamp.
        attribute(:voidable_until, String, from: "voidableUntil")
      end
    end
  end
end
