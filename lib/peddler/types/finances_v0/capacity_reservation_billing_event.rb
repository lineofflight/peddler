# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

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

        # @return [Types::Money] The amount of the capacity reservation billing event.
        attribute(:transaction_amount, Types::Money, from: "TransactionAmount")
      end
    end
  end
end
