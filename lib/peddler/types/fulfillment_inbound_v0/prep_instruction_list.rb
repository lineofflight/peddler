# frozen_string_literal: true

module Peddler
  module Types
    module FulfillmentInboundV0
      # A list of preparation instructions to help with item sourcing decisions.
      class PrepInstructionList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array)
          end
        end
      end
    end
  end
end
