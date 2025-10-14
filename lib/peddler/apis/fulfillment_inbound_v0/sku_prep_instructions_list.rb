# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FulfillmentInboundV0
      # A list of SKU labeling requirements and item preparation instructions.
      class SKUPrepInstructionsList < Array
        class << self
          def parse(array)
            new(array.map { |item| SKUPrepInstructions.parse(item) })
          end
        end
      end
    end
  end
end
