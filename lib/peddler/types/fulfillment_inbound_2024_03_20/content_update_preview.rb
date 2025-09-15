# frozen_string_literal: true

require "peddler/types/fulfillment_inbound_2024_03_20/requested_updates"
require "peddler/types/fulfillment_inbound_2024_03_20/transportation_option"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Preview of the changes that will be applied to the shipment.
      ContentUpdatePreview = Structure.new do
        # @return [String] Identifier of a content update preview.
        attribute(:content_update_preview_id, String, from: "contentUpdatePreviewId")

        # @return [String] The time at which the content update expires. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern
        # `yyyy-MM-ddTHH:mm:ss.sssZ`.
        attribute(:expiration, String)

        # @return [RequestedUpdates]
        attribute(:requested_updates, RequestedUpdates, from: "requestedUpdates")

        # @return [TransportationOption]
        attribute(:transportation_option, TransportationOption, from: "transportationOption")
      end
    end
  end
end
