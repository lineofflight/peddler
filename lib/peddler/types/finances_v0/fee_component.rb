# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

module Peddler
  module Types
    module FinancesV0
      # A fee associated with the event.
      FeeComponent = Structure.new do
        # @return [String] The type of fee. For more information about Selling on Amazon fees, see [Selling on Amazon
        # Fee Schedule](https://sellercentral.amazon.com/gp/help/200336920) on Seller Central. For more information
        # about Fulfillment by Amazon fees, see [FBA features, services and
        # fees](https://sellercentral.amazon.com/gp/help/201074400) on Seller Central.
        attribute(:fee_type, String, from: "FeeType")

        # @return [Money] The amount of the fee.
        attribute(:fee_amount, Money, from: "FeeAmount")
      end
    end
  end
end
