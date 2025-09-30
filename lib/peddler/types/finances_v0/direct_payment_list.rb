# frozen_string_literal: true

require "peddler/types/finances_v0/direct_payment"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of direct payment information.
      class DirectPaymentList < Array
        class << self
          def parse(array)
            new(array.map { |item| DirectPayment.parse(item) })
          end
        end
      end
    end
  end
end
