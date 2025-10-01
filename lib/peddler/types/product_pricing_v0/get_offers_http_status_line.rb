# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ProductPricingV0
      # The HTTP status line associated with the response. For more information, consult [RFC
      # 2616](https://www.w3.org/Protocols/rfc2616/rfc2616-sec6.html).
      GetOffersHttpStatusLine = Structure.new do
        # @return [String] The HTTP response Reason-Phase.
        attribute?(:reason_phrase, String, from: "reasonPhrase")

        # @return [Integer] The HTTP response Status Code.
        attribute?(:status_code, Integer, from: "statusCode")
      end
    end
  end
end
