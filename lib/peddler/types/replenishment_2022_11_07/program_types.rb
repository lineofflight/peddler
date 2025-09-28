# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module Replenishment20221107
      # A list of replenishment program types.
      class ProgramTypes < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array) : new
          end
        end
      end
    end
  end
end
