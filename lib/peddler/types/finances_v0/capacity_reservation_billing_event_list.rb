# frozen_string_literal: true

require "peddler/types/finances_v0/capacity_reservation_billing_event"

module Peddler
  module Types
    module FinancesV0
      # A list of `CapacityReservationBillingEvent` events.
      class CapacityReservationBillingEventList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| CapacityReservationBillingEvent.parse(item) })
          end
        end
      end
    end
  end
end
