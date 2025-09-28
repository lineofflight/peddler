# frozen_string_literal: true

require "peddler/types/finances_v0/adjustment_item"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of information about items in an adjustment to the seller's account.
      class AdjustmentItemList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| AdjustmentItem.parse(item) }) : new
          end
        end
      end
    end
  end
end
