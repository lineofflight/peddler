# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_outbound_2020_07_01/error"
require "peddler/types/fulfillment_outbound_2020_07_01/list_return_reason_codes_result"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The response schema for the `listReturnReasonCodes` operation.
      ListReturnReasonCodesResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the `listReturnReasonCodes` operation.
        attribute?(:errors, [Error])

        # @return [ListReturnReasonCodesResult] The payload for the `listReturnReasonCodes` operation.
        attribute?(:payload, ListReturnReasonCodesResult)
      end
    end
  end
end
