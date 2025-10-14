# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class Finances20240619
      # Contains transactions within a given time period.
      class Transactions < Array
        class << self
          def parse(array)
            new(array.map { |item| Transaction.parse(item) })
          end
        end
      end
    end
  end
end
