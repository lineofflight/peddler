# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_outbound_2020_07_01/fulfillment_preview"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # A list of fulfillment order previews, including estimated shipping weights, estimated shipping fees, and
      # estimated ship dates and arrival dates.
      GetFulfillmentPreviewResult = Structure.new do
        # @return [Array<FulfillmentPreview>]
        attribute(:fulfillment_previews, [FulfillmentPreview], from: "fulfillmentPreviews")
      end
    end
  end
end
