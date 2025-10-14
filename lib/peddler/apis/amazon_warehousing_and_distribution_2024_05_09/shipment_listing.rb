# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # A list of inbound shipment summaries filtered by the attributes specified in the request.
      ShipmentListing = Structure.new do
        # @return [String] A token that is used to retrieve the next page of results. The response includes `nextToken`
        # when the number of results exceeds the specified `maxResults` value. To get the next page of results, call the
        # operation with this token and include the same arguments as the call that produced the token. To get a
        # complete list, call this operation until `nextToken` is null. Note that this operation can return empty pages.
        attribute?(:next_token, String, from: "nextToken")

        # @return [Array<InboundShipmentSummary>] List of inbound shipment summaries.
        attribute?(:shipments, [InboundShipmentSummary])
      end
    end
  end
end
