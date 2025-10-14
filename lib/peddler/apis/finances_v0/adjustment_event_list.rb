# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FinancesV0
      # A list of adjustment event information for the seller's account.
      class AdjustmentEventList < Array
        class << self
          def parse(array)
            new(array.map { |item| AdjustmentEvent.parse(item) })
          end
        end
      end
    end
  end
end
