# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_inbound_v0/error"
require "peddler/types/fulfillment_inbound_v0/get_prep_instructions_result"

module Peddler
  module Types
    module FulfillmentInboundV0
      # The response schema for the getPrepInstructions operation.
      GetPrepInstructionsResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [GetPrepInstructionsResult] The payload for the getPrepInstructions operation.
        attribute?(:payload, GetPrepInstructionsResult)
      end
    end
  end
end
