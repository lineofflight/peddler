# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # An event related to a capacity reservation billing charge.
      CapacityReservationBillingEvent = Structure.new do
        # A short description of the capacity reservation billing event.
        attribute?(:description, String, from: "Description")

        # The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # The amount of the capacity reservation billing event.
        attribute?(:transaction_amount, Money, from: "TransactionAmount")

        # The transaction type. For example, FBA Inventory Fee.
        attribute?(:transaction_type, String, from: "TransactionType")
      end
    end
  end
end
