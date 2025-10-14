# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # A list of fulfillment order previews, including estimated shipping weights, estimated shipping fees, and
      # estimated ship dates and arrival dates.
      GetFulfillmentPreviewResult = Structure.new do
        # @return [Array<FulfillmentPreview>]
        attribute?(:fulfillment_previews, [FulfillmentPreview], from: "fulfillmentPreviews")
      end
    end
  end
end
