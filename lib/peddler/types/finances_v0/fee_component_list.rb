# frozen_string_literal: true

require "peddler/types/finances_v0/fee_component"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of fee component information.
      class FeeComponentList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| FeeComponent.parse(item) }) : new
          end
        end
      end
    end
  end
end
