# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Fulfillment configuration for preview request.
      PreviewFulfillmentConfiguration = Structure.new do
        # @return [PreviewServiceLevel]
        attribute?(:service_level, PreviewServiceLevel, from: "serviceLevel")

        # @return [PreviewServices] Services for the preview.
        attribute?(:services, PreviewServices)
      end
    end
  end
end
