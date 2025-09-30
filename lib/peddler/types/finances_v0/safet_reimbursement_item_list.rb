# frozen_string_literal: true

require "peddler/types/finances_v0/safet_reimbursement_item"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of SAFETReimbursementItems.
      class SAFETReimbursementItemList < Array
        class << self
          def parse(array)
            new(array.map { |item| SAFETReimbursementItem.parse(item) })
          end
        end
      end
    end
  end
end
