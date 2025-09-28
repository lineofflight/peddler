# frozen_string_literal: true

require "peddler/types/finances_v0/adhoc_disbursement_event"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of `AdhocDisbursement` events.
      class AdhocDisbursementEventList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| AdhocDisbursementEvent.parse(item) }) : new
          end
        end
      end
    end
  end
end
