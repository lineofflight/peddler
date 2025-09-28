# frozen_string_literal: true

require "peddler/types/finances_v0/financial_event_group"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of financial event group information.
      class FinancialEventGroupList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| FinancialEventGroup.parse(item) }) : new
          end
        end
      end
    end
  end
end
