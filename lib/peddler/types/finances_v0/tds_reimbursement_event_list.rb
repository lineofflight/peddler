# frozen_string_literal: true

require "peddler/types/finances_v0/tds_reimbursement_event"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of `TDSReimbursementEvent` items.
      class TDSReimbursementEventList < Array
        class << self
          def parse(array)
            new(array.map { |item| TDSReimbursementEvent.parse(item) })
          end
        end
      end
    end
  end
end
