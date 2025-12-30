# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class FinancesV0
      # A list of `SAFETReimbursementEvent`.
      class SAFETReimbursementEventList < Array
        class << self
          def parse(array)
            new(array.map { |item| SAFETReimbursementEvent.parse(item) })
          end
        end
      end
    end
  end
end
