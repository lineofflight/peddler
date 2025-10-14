# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
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
