# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInboundV0
      # The response schema for the getPrepInstructions operation.
      GetPrepInstructionsResponse = Structure.new do
        attribute?(:errors, [Error])

        # The payload for the getPrepInstructions operation.
        attribute?(:payload, GetPrepInstructionsResult)
      end
    end
  end
end
