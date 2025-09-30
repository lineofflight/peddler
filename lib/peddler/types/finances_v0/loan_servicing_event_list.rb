# frozen_string_literal: true

require "peddler/types/finances_v0/loan_servicing_event"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of loan servicing events.
      class LoanServicingEventList < Array
        class << self
          def parse(array)
            new(array.map { |item| LoanServicingEvent.parse(item) })
          end
        end
      end
    end
  end
end
