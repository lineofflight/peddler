# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `listTransportationOptions` response.
      ListTransportationOptionsResponse = Structure.new do
        # @return [Array<TransportationOption>] Transportation options generated for the placement option.
        attribute(:transportation_options, [TransportationOption], null: false, from: "transportationOptions")

        # @return [Pagination]
        attribute?(:pagination, Pagination)
      end
    end
  end
end
