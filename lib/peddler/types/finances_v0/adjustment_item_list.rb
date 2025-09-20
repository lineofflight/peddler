# frozen_string_literal: true

require "peddler/types/finances_v0/adjustment_item"

module Peddler
  module Types
    module FinancesV0
      # A list of information about items in an adjustment to the seller's account.
      class AdjustmentItemList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| AdjustmentItem.parse(item) })
          end
        end
      end
    end
  end
end
