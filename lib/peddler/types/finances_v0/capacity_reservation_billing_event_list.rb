# frozen_string_literal: true

require "peddler/types/finances_v0/capacity_reservation_billing_event"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of `CapacityReservationBillingEvent` events.
      class CapacityReservationBillingEventList < Array
        class << self
          def parse(array)
            new(array.map { |item| CapacityReservationBillingEvent.parse(item) })
          end
        end
      end
    end
  end
end
