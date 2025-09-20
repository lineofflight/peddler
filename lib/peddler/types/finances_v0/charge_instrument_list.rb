# frozen_string_literal: true

require "peddler/types/finances_v0/charge_instrument"

module Peddler
  module Types
    module FinancesV0
      # A list of payment instruments.
      class ChargeInstrumentList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| ChargeInstrument.parse(item) })
          end
        end
      end
    end
  end
end
