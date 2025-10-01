# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/money"
require "structure"

module Peddler
  module Types
    module FinancesV0
      # An event related to an Adhoc Disbursement.
      AdhocDisbursementEvent = Structure.new do
        # @return [String] The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # @return [Money] The amount of the transaction.
        attribute?(:transaction_amount, Money, from: "TransactionAmount")

        # @return [String] The identifier for the transaction.
        attribute?(:transaction_id, String, from: "TransactionId")

        # @return [String] Indicates the type of transaction.
        #
        # Example: "Disbursed to Amazon Gift Card balance"
        attribute?(:transaction_type, String, from: "TransactionType")
      end
    end
  end
end
