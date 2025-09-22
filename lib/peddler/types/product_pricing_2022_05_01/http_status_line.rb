# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ProductPricing20220501
      # The HTTP status line associated with the response for an individual request within a batch. For more
      # information, refer to [RFC 2616](https://www.w3.org/Protocols/rfc2616/rfc2616-sec6.html).
      HttpStatusLine = Structure.new do
        # @return [Integer] The HTTP response status code.
        attribute(:status_code, Integer, from: "statusCode")

        # @return [String] The HTTP response reason phrase.
        attribute(:reason_phrase, String, from: "reasonPhrase")
      end
    end
  end
end
