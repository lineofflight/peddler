# frozen_string_literal: true

require "peddler/types/finances_v0/retrocharge_event"

module Peddler
  module Types
    module FinancesV0
      # A list of information about Retrocharge or RetrochargeReversal events.
      class RetrochargeEventList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| RetrochargeEvent.parse(item) })
          end
        end
      end
    end
  end
end
