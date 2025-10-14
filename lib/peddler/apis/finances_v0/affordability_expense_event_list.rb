# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FinancesV0
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
