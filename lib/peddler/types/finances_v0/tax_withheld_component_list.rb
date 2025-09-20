# frozen_string_literal: true

require "peddler/types/finances_v0/tax_withheld_component"

module Peddler
  module Types
    module FinancesV0
      # A list of information about taxes withheld.
      class TaxWithheldComponentList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| TaxWithheldComponent.parse(item) })
          end
        end
      end
    end
  end
end
