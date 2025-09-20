# frozen_string_literal: true

require "peddler/types/finances_v0/loan_servicing_event"

module Peddler
  module Types
    module FinancesV0
      # A list of loan servicing events.
      class LoanServicingEventList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| LoanServicingEvent.parse(item) })
          end
        end
      end
    end
  end
end
