# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/product_pricing_2022_05_01/competitive_summary_response_body"
require "peddler/types/product_pricing_2022_05_01/http_status_line"

module Peddler
  module Types
    module ProductPricing20220501
      # The response for the individual `competitiveSummary` request in the batch operation.
      CompetitiveSummaryResponse = Structure.new do
        # @return [CompetitiveSummaryResponseBody] The `competitiveSummaryResponse` body for a requested ASIN and
        # `marketplaceId`.
        attribute(:body, CompetitiveSummaryResponseBody)

        # @return [HttpStatusLine] The HTTP status line associated with the response. For more information, refer to
        # [RFC 2616](https://www.w3.org/Protocols/rfc2616/rfc2616-sec6.html).
        attribute(:status, HttpStatusLine)
      end
    end
  end
end
