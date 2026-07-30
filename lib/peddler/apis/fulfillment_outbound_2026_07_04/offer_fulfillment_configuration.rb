# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Fulfillment configuration for offers request.
      OfferFulfillmentConfiguration = Structure.new do
        # @return [PreviewServiceLevel]
        attribute?(:service_level, PreviewServiceLevel, from: "serviceLevel")
      end
    end
  end
end
