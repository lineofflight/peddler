# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Contains only a starting DateTime.
      WindowInput = Structure.new do
        # @return [Time] The start date of the window. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with minute precision. Supports
        # patterns `yyyy-MM-ddTHH:mmZ`, `yyyy-MM-ddTHH:mm:ssZ`, or `yyyy-MM-ddTHH:mm:ss.sssZ`. Note that non-zero second
        # and millisecond components are removed.
        attribute(:start, Time)
      end
    end
  end
end
