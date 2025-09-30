# frozen_string_literal: true

require "peddler/types/fulfillment_inbound_v0/asin_prep_instructions"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FulfillmentInboundV0
      # A list of item preparation instructions.
      class ASINPrepInstructionsList < Array
        class << self
          def parse(array)
            new(array.map { |item| ASINPrepInstructions.parse(item) })
          end
        end
      end
    end
  end
end
