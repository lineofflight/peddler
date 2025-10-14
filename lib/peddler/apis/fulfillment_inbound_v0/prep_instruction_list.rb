# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FulfillmentInboundV0
      # A list of preparation instructions to help with item sourcing decisions.
      class PrepInstructionList < Array
        class << self
          def parse(array)
            new(array)
          end
        end
      end
    end
  end
end
