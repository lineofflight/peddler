# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # The HTTP status line associated with the response for an individual request within a batch. For more
      # information, refer to [RFC 2616](https://www.w3.org/Protocols/rfc2616/rfc2616-sec6.html).
      HttpStatusLine = Structure.new do
        # @return [String] The HTTP response reason phrase.
        attribute?(:reason_phrase, String, from: "reasonPhrase")

        # @return [Integer] The HTTP response status code.
        attribute?(:status_code, Integer, from: "statusCode")
      end
    end
  end
end
