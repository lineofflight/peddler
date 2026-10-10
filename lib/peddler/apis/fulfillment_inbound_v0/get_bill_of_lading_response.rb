# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInboundV0
      # The response schema for the getBillOfLading operation.
      GetBillOfLadingResponse = Structure.new do
        attribute?(:errors, [Error])

        # The payload for the getBillOfLading operation.
        attribute?(:payload, BillOfLadingDownloadURL)
      end
    end
  end
end
