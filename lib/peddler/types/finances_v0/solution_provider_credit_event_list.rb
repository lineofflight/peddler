# frozen_string_literal: true

require "peddler/types/finances_v0/solution_provider_credit_event"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of information about solution provider credits.
      class SolutionProviderCreditEventList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| SolutionProviderCreditEvent.parse(item) }) : new
          end
        end
      end
    end
  end
end
