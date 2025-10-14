# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The estimated shipping cost associated with the transportation option.
      Quote = Structure.new do
        # @return [Money]
        attribute(:cost, Money)

        # @return [Time] The time at which this transportation option quote expires. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime with pattern
        # `yyyy-MM-ddTHH:mm:ss.sssZ`.
        attribute?(:expiration, Time)

        # @return [Time] Voidable until timestamp.
        attribute?(:voidable_until, Time, from: "voidableUntil")
      end
    end
  end
end
