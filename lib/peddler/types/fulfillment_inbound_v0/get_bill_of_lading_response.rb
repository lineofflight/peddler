# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_v0/bill_of_lading_download_url"
require "peddler/types/fulfillment_inbound_v0/error"

module Peddler
  module Types
    module FulfillmentInboundV0
      # The response schema for the getBillOfLading operation.
      GetBillOfLadingResponse = Structure.new do
        # @return [BillOfLadingDownloadURL] The payload for the getBillOfLading operation.
        attribute(:payload, BillOfLadingDownloadURL)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
