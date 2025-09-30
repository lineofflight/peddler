# frozen_string_literal: true

require "peddler/types/finances_v0/debt_recovery_event"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of debt recovery event information.
      class DebtRecoveryEventList < Array
        class << self
          def parse(array)
            new(array.map { |item| DebtRecoveryEvent.parse(item) })
          end
        end
      end
    end
  end
end
