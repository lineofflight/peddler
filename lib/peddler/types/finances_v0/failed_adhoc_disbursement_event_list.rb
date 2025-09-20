# frozen_string_literal: true

require "peddler/types/finances_v0/failed_adhoc_disbursement_event"

module Peddler
  module Types
    module FinancesV0
      # A list of `FailedAdhocDisbursementEvent`s.
      class FailedAdhocDisbursementEventList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| FailedAdhocDisbursementEvent.parse(item) })
          end
        end
      end
    end
  end
end
