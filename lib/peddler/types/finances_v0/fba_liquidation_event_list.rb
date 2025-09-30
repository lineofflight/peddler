# frozen_string_literal: true

require "peddler/types/finances_v0/fba_liquidation_event"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of FBA inventory liquidation payment events.
      class FBALiquidationEventList < Array
        class << self
          def parse(array)
            new(array.map { |item| FBALiquidationEvent.parse(item) })
          end
        end
      end
    end
  end
end
