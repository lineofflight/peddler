# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/pagination"
require "peddler/types/fulfillment_inbound_2024_03_20/transportation_option"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `listTransportationOptions` response.
      ListTransportationOptionsResponse = Structure.new do
        # @return [Pagination]
        attribute(:pagination, Pagination)

        # @return [Array<TransportationOption>] Transportation options generated for the placement option.
        attribute(:transportation_options, [TransportationOption], from: "transportationOptions")
      end
    end
  end
end
