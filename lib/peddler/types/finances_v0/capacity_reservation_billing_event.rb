# frozen_string_literal: true

require "peddler/types/finances_v0/currency"

module Peddler
  module Types
    module FinancesV0
      # An event related to a capacity reservation billing charge.
      CapacityReservationBillingEvent = Structure.new do
        # @return [String] Indicates the type of transaction. For example, FBA Inventory Fee
        attribute(:transaction_type, String, from: "TransactionType")

        # @return [String] The date and time when the financial event was posted.
        attribute(:posted_date, String, from: "PostedDate")

        # @return [String] A short description of the capacity reservation billing event.
        attribute(:description, String, from: "Description")

        # @return [Currency] The amount of the capacity reservation billing event.
        attribute(:transaction_amount, Currency, from: "TransactionAmount")
      end
    end
  end
end
