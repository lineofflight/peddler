# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricing20220501
      # The response for the individual `competitiveSummary` request in the batch operation.
      CompetitiveSummaryResponse = Structure.new do
        # The `competitiveSummaryResponse` body for a requested ASIN and `marketplaceId`.
        attribute(:body, CompetitiveSummaryResponseBody, null: false)

        # The HTTP status line associated with the response. For more information, refer to [RFC
        # 2616](https://www.w3.org/Protocols/rfc2616/rfc2616-sec6.html).
        attribute(:status, HttpStatusLine, null: false)
      end
    end
  end
end
