# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # The `ListShipmentContentUpdatePreviews` response.
      ListShipmentContentUpdatePreviewsResponse = Structure.new do
        # A list of content update previews in a shipment.
        attribute(:content_update_previews, [ContentUpdatePreview], null: false, from: "contentUpdatePreviews")

        attribute?(:pagination, Pagination)
      end
    end
  end
end
