# frozen_string_literal: true

require "peddler/types/finances_v0/value_added_service_charge_event"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of `ValueAddedServiceCharge` events.
      class ValueAddedServiceChargeEventList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| ValueAddedServiceChargeEvent.parse(item) }) : new
          end
        end
      end
    end
  end
end
