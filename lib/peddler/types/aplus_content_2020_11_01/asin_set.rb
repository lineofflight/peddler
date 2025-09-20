# frozen_string_literal: true

module Peddler
  module Types
    module AplusContent20201101
      # The set of ASINs.
      class AsinSet < Array
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
