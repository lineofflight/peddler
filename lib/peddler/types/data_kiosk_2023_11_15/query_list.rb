# frozen_string_literal: true

require "peddler/types/data_kiosk_2023_11_15/query"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module DataKiosk20231115
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
