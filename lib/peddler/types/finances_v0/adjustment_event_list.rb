# frozen_string_literal: true

require "peddler/types/finances_v0/adjustment_event"

module Peddler
  module Types
    module FinancesV0
      # A list of adjustment event information for the seller's account.
      class AdjustmentEventList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| AdjustmentEvent.parse(item) })
          end
        end
      end
    end
  end
end
