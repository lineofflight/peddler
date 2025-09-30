# frozen_string_literal: true

require "peddler/types/finances_v0/pay_with_amazon_event"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module FinancesV0
      # A list of events related to the seller's Pay with Amazon account.
      class PayWithAmazonEventList < Array
        class << self
          def parse(array)
            new(array.map { |item| PayWithAmazonEvent.parse(item) })
          end
        end
      end
    end
  end
end
