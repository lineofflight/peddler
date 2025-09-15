# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ProductPricingV0
      # A mapping of additional HTTP headers to send/receive for the individual batch request.
      HttpResponseHeaders = Structure.new do
        # @return [String] The timestamp that the API request was received. For more information, consult [RFC 2616
        # Section 14](https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html).
        attribute(:date, String, from: "Date")

        # @return [String] Unique request reference identifier.
        attribute(:x_amzn_request_id, String, from: "x-amzn-RequestId")
      end
    end
  end
end
