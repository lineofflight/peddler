# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_inbound_v0/error"
require "peddler/types/fulfillment_inbound_v0/bill_of_lading_download_url"

module Peddler
  module Types
    module FulfillmentInboundV0
      # The response schema for the getBillOfLading operation.
      GetBillOfLadingResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [BillOfLadingDownloadURL] The payload for the getBillOfLading operation.
        attribute?(:payload, BillOfLadingDownloadURL)
      end
    end
  end
end
