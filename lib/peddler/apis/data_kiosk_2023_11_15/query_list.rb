# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class DataKiosk20231115
      # A list of queries.
      class QueryList < Array
        class << self
          def parse(array)
            new(array.map { |item| Query.parse(item) })
          end
        end
      end
    end
  end
end
