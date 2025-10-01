# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_outbound_2020_07_01/error"
require "peddler/types/fulfillment_outbound_2020_07_01/get_fulfillment_preview_result"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The response schema for the `getFulfillmentPreview` operation.
      GetFulfillmentPreviewResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `getFulfillmentPreview` operation.
        attribute?(:errors, [Error])

        # @return [GetFulfillmentPreviewResult] The response payload for the `getFulfillmentPreview` operation.
        attribute?(:payload, GetFulfillmentPreviewResult)
      end
    end
  end
end
