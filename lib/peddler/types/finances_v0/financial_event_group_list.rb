# frozen_string_literal: true

require "peddler/types/finances_v0/financial_event_group"

module Peddler
  module Types
    module FinancesV0
      # A list of financial event group information.
      class FinancialEventGroupList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| FinancialEventGroup.parse(item) })
          end
        end
      end
    end
  end
end
