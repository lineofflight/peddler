# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # Preview of the changes that will be applied to the shipment.
      ContentUpdatePreview = Structure.new do
        # Identifier of a content update preview.
        attribute(:content_update_preview_id, String, null: false, from: "contentUpdatePreviewId")

        # The time at which the content update expires. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern
        # `yyyy-MM-ddTHH:mm:ss.sssZ`.
        attribute(:expiration, Time, null: false)

        attribute(:requested_updates, RequestedUpdates, null: false, from: "requestedUpdates")

        attribute(:transportation_option, TransportationOption, null: false, from: "transportationOption")
      end
    end
  end
end
