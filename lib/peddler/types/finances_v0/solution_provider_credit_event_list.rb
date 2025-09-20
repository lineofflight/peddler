# frozen_string_literal: true

require "peddler/types/finances_v0/solution_provider_credit_event"

module Peddler
  module Types
    module FinancesV0
      # A list of information about solution provider credits.
      class SolutionProviderCreditEventList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| SolutionProviderCreditEvent.parse(item) })
          end
        end
      end
    end
  end
end
