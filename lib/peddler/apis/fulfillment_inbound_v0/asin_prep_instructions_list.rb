# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FulfillmentInboundV0
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
