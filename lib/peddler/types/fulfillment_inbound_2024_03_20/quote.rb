# frozen_string_literal: true

require "peddler/types/fulfillment_inbound_2024_03_20/currency"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The estimated shipping cost associated with the transportation option.
      Quote = Structure.new do
        # @return [Currency]
        attribute(:cost, Currency)

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
