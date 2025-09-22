# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

module Peddler
  module Types
    module FinancesV0
      # An event related to an Adhoc Disbursement.
      AdhocDisbursementEvent = Structure.new do
        # @return [String] Indicates the type of transaction.
        #
        # Example: "Disbursed to Amazon Gift Card balance"
        attribute(:transaction_type, String, from: "TransactionType")

        # @return [String] The date and time when the financial event was posted.
        attribute(:posted_date, String, from: "PostedDate")

        # @return [String] The identifier for the transaction.
        attribute(:transaction_id, String, from: "TransactionId")

        # @return [Money] The amount of the transaction.
        attribute(:transaction_amount, Money, from: "TransactionAmount")
      end
    end
  end
end
