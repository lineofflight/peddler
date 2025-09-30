# frozen_string_literal: true

require "peddler/types/finances_v0/safet_reimbursement_event"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of SAFETReimbursementEvents.
      class SAFETReimbursementEventList < Array
        class << self
          def parse(array)
            new(array.map { |item| SAFETReimbursementEvent.parse(item) })
          end
        end
      end
    end
  end
end
