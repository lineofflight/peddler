# frozen_string_literal: true

require "peddler/types/finances_2024_06_19/item"

module Peddler
  module Types
    module Finances20240619
      # List of items in the transaction
      class Items < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| Item.parse(item) })
          end
        end
      end
    end
  end
end
