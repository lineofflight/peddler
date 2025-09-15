# frozen_string_literal: true

require "peddler/types/fulfillment_inbound_v0/get_prep_instructions_result"
require "peddler/types/fulfillment_inbound_v0/error"

module Peddler
  module Types
    module FulfillmentInboundV0
      # The response schema for the getPrepInstructions operation.
      GetPrepInstructionsResponse = Structure.new do
        # @return [GetPrepInstructionsResult] The payload for the getPrepInstructions operation.
        attribute(:payload, GetPrepInstructionsResult)

        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
