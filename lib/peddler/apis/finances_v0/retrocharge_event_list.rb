# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FinancesV0
      # A list of information about Retrocharge or RetrochargeReversal events.
      class RetrochargeEventList < Array
        class << self
          def parse(array)
            new(array.map { |item| RetrochargeEvent.parse(item) })
          end
        end
      end
    end
  end
end
