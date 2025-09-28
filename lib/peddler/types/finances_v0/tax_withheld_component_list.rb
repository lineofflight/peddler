# frozen_string_literal: true

require "peddler/types/finances_v0/tax_withheld_component"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of information about taxes withheld.
      class TaxWithheldComponentList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| TaxWithheldComponent.parse(item) }) : new
          end
        end
      end
    end
  end
end
