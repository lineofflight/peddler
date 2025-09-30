# frozen_string_literal: true

require "peddler/types/finances_v0/network_commingling_transaction_event"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
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
