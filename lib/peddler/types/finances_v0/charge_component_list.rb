# frozen_string_literal: true

require "peddler/types/finances_v0/charge_component"

module Peddler
  module Types
    module FinancesV0
      # A list of charge information on the seller's account.
      class ChargeComponentList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ChargeComponent.parse(item) })
          end
        end
      end
    end
  end
end
