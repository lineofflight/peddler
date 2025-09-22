# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_outbound_2020_07_01/list_return_reason_codes_result"
require "peddler/types/fulfillment_outbound_2020_07_01/error"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The response schema for the `listReturnReasonCodes` operation.
      ListReturnReasonCodesResponse = Structure.new do
        # @return [ListReturnReasonCodesResult] The payload for the `listReturnReasonCodes` operation.
        attribute(:payload, ListReturnReasonCodesResult)

        # @return [Array<Error>] One or more unexpected errors occurred during the `listReturnReasonCodes` operation.
        attribute(:errors, [Error])
      end
    end
  end
end
