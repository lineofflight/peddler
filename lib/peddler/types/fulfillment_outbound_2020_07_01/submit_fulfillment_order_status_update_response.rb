# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_outbound_2020_07_01/error"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The response schema for the `SubmitFulfillmentOrderStatusUpdate` operation.
      SubmitFulfillmentOrderStatusUpdateResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `SubmitFulfillmentOrderStatusUpdate`
        # operation.
        attribute?(:errors, [Error])
      end
    end
  end
end
