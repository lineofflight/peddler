# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20200701
      # The response schema for the `listReturnReasonCodes` operation.
      ListReturnReasonCodesResponse = Structure.new do
        # One or more unexpected errors occurred during the `listReturnReasonCodes` operation.
        attribute?(:errors, [Error])

        # The payload for the `listReturnReasonCodes` operation.
        attribute?(:payload, ListReturnReasonCodesResult)
      end
    end
  end
end
