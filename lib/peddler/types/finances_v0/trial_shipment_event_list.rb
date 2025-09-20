# frozen_string_literal: true

require "peddler/types/finances_v0/trial_shipment_event"

module Peddler
  module Types
    module FinancesV0
      # A list of information about trial shipment financial events.
      class TrialShipmentEventList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| TrialShipmentEvent.parse(item) })
          end
        end
      end
    end
  end
end
