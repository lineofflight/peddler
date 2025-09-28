# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module SupplySources20200701
      # The list of `SupplySource`s.
      class SupplySourceList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array) : new
          end
        end
      end
    end
  end
end
