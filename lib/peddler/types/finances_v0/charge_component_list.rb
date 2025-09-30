# frozen_string_literal: true

require "peddler/types/finances_v0/charge_component"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of charge information on the seller's account.
      class ChargeComponentList < Array
        class << self
          def parse(array)
            new(array.map { |item| ChargeComponent.parse(item) })
          end
        end
      end
    end
  end
end
