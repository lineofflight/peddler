# frozen_string_literal: true

require "peddler/types/finances_2024_06_19/breakdown"

module Peddler
  module Types
    module Finances20240619
      # A list of breakdowns that detail how the total amount is calculated for the transaction.
      class Breakdowns < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| Breakdown.parse(item) })
          end
        end
      end
    end
  end
end
