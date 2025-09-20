# frozen_string_literal: true

require "peddler/types/finances_v0/safet_reimbursement_item"

module Peddler
  module Types
    module FinancesV0
      # A list of SAFETReimbursementItems.
      class SAFETReimbursementItemList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| SAFETReimbursementItem.parse(item) })
          end
        end
      end
    end
  end
end
