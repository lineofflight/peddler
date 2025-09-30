# frozen_string_literal: true

require "peddler/types/finances_v0/affordability_expense_event"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of expense information related to an affordability promotion.
      class AffordabilityExpenseEventList < Array
        class << self
          def parse(array)
            new(array.map { |item| AffordabilityExpenseEvent.parse(item) })
          end
        end
      end
    end
  end
end
