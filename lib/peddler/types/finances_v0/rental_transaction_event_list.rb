# frozen_string_literal: true

require "peddler/types/finances_v0/rental_transaction_event"

module Peddler
  module Types
    module FinancesV0
      # A list of rental transaction event information.
      class RentalTransactionEventList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| RentalTransactionEvent.parse(item) })
          end
        end
      end
    end
  end
end
