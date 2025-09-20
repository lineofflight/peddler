# frozen_string_literal: true

module Peddler
  module Types
    module Replenishment20221107
      # A list of replenishment program types.
      class ProgramTypes < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array)
          end
        end
      end
    end
  end
end
