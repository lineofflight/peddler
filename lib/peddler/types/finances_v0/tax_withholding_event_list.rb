# frozen_string_literal: true

require "peddler/types/finances_v0/tax_withholding_event"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of `TaxWithholding` events.
      class TaxWithholdingEventList < Array
        class << self
          def parse(array)
            new(array.map { |item| TaxWithholdingEvent.parse(item) })
          end
        end
      end
    end
  end
end
