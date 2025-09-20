# frozen_string_literal: true

require "peddler/types/finances_2024_06_19/transaction"

module Peddler
  module Types
    module Finances20240619
      # Contains transactions within a given time period.
      class Transactions < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| Transaction.parse(item) })
          end
        end
      end
    end
  end
end
