# frozen_string_literal: true

require "peddler/types/fulfillment_inbound_v0/asin_prep_instructions"

module Peddler
  module Types
    module FulfillmentInboundV0
      # A list of item preparation instructions.
      class ASINPrepInstructionsList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ASINPrepInstructions.parse(item) })
          end
        end
      end
    end
  end
end
