# frozen_string_literal: true

module Peddler
  module Types
    module SupplySources20200701
      # The list of `SupplySource`s.
      class SupplySourceList < Array
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
