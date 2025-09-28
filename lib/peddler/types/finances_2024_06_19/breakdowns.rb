# frozen_string_literal: true

require "peddler/types/finances_2024_06_19/breakdown"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module Finances20240619
      # A list of breakdowns that detail how the total amount is calculated for the transaction.
      class Breakdowns < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| Breakdown.parse(item) }) : new
          end
        end
      end
    end
  end
end
