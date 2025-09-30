# frozen_string_literal: true

require "peddler/types/finances_v0/charge_refund_event"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of charge refund events.
      class ChargeRefundEventList < Array
        class << self
          def parse(array)
            new(array.map { |item| ChargeRefundEvent.parse(item) })
          end
        end
      end
    end
  end
end
