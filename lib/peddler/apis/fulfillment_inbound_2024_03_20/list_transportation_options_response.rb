# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # The `listTransportationOptions` response.
      ListTransportationOptionsResponse = Structure.new do
        # Transportation options generated for the placement option.
        attribute(:transportation_options, [TransportationOption], null: false, from: "transportationOptions")

        attribute?(:pagination, Pagination)
      end
    end
  end
end
