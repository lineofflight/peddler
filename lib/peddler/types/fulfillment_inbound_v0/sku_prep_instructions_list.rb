# frozen_string_literal: true

require "peddler/types/fulfillment_inbound_v0/sku_prep_instructions"

module Peddler
  module Types
    module FulfillmentInboundV0
      # A list of SKU labeling requirements and item preparation instructions.
      class SKUPrepInstructionsList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| SKUPrepInstructions.parse(item) })
          end
        end
      end
    end
  end
end
