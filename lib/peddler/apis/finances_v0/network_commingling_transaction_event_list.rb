# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FinancesV0
      # A list of network commingling transaction events.
      class NetworkComminglingTransactionEventList < Array
        class << self
          def parse(array)
            new(array.map { |item| NetworkComminglingTransactionEvent.parse(item) })
          end
        end
      end
    end
  end
end
