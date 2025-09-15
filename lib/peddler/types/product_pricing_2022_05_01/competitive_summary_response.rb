# frozen_string_literal: true

require "peddler/types/product_pricing_2022_05_01/http_status_line"
require "peddler/types/product_pricing_2022_05_01/competitive_summary_response_body"

module Peddler
  module Types
    module ProductPricing20220501
      # The response for the individual `competitiveSummary` request in the batch operation.
      CompetitiveSummaryResponse = Structure.new do
        # @return [HttpStatusLine] The HTTP status line associated with the response. For more information, refer to
        # [RFC 2616](https://www.w3.org/Protocols/rfc2616/rfc2616-sec6.html).
        attribute(:status, HttpStatusLine)

        # @return [CompetitiveSummaryResponseBody] The `competitiveSummaryResponse` body for a requested ASIN and
        # `marketplaceId`.
        attribute(:body, CompetitiveSummaryResponseBody)
      end
    end
  end
end
