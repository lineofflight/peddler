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
            array.is_a?(Array) ? new(array.map { |item| DebtRecoveryEvent.parse(item) }) : new
          end
        end
      end
    end
  end
end
