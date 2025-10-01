# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_inbound_2024_03_20/transportation_option"
require "peddler/types/fulfillment_inbound_2024_03_20/pagination"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `listTransportationOptions` response.
      ListTransportationOptionsResponse = Structure.new do
        # @return [Array<TransportationOption>] Transportation options generated for the placement option.
        attribute(:transportation_options, [TransportationOption], from: "transportationOptions")

        # @return [Pagination]
        attribute?(:pagination, Pagination)
      end
    end
  end
end
