# frozen_string_literal: true

require "peddler/types/finances_v0/rental_transaction_event"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of rental transaction event information.
      class RentalTransactionEventList < Array
        class << self
          def parse(array)
            new(array.map { |item| RentalTransactionEvent.parse(item) })
          end
        end
      end
    end
  end
end
