# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Services for a fulfillment preview request. Does not include delivery settings.
      PreviewServices = Structure.new do
        # @return [Hash] Additional services for the fulfillment preview.
        attribute?(:additional, Hash)

        # @return [PreviewPackagingService] The packaging settings for the fulfillment preview.
        attribute?(:packaging, PreviewPackagingService)
      end
    end
  end
end
