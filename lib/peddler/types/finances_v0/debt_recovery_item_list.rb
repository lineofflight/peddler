# frozen_string_literal: true

require "peddler/types/finances_v0/debt_recovery_item"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of debt recovery item information.
      class DebtRecoveryItemList < Array
        class << self
          def parse(array)
            new(array.map { |item| DebtRecoveryItem.parse(item) })
          end
        end
      end
    end
  end
end
