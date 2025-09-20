# frozen_string_literal: true

require "peddler/types/finances_v0/fee_component"

module Peddler
  module Types
    module FinancesV0
      # A list of fee component information.
      class FeeComponentList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| FeeComponent.parse(item) })
          end
        end
      end
    end
  end
end
