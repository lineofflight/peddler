# frozen_string_literal: true

require "peddler/types/finances_v0/tds_reimbursement_event"

module Peddler
  module Types
    module FinancesV0
      # A list of `TDSReimbursementEvent` items.
      class TDSReimbursementEventList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| TDSReimbursementEvent.parse(item) })
          end
        end
      end
    end
  end
end
