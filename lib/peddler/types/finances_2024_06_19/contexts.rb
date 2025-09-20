# frozen_string_literal: true

require "peddler/types/finances_2024_06_19/context"

module Peddler
  module Types
    module Finances20240619
      # List of additional Information about the item.
      class Contexts < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| Context.parse(item) })
          end
        end
      end
    end
  end
end
