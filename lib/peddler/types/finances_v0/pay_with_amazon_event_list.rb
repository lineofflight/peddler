# frozen_string_literal: true

require "peddler/types/finances_v0/pay_with_amazon_event"

module Peddler
  module Types
    module FinancesV0
      # A list of events related to the seller's Pay with Amazon account.
      class PayWithAmazonEventList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| PayWithAmazonEvent.parse(item) })
          end
        end
      end
    end
  end
end
