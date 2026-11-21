# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # An event related to an Adhoc Disbursement.
      AdhocDisbursementEvent = Structure.new do
        # The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # The amount of the transaction.
        attribute?(:transaction_amount, Money, from: "TransactionAmount")

        # The identifier for the transaction.
        attribute?(:transaction_id, String, from: "TransactionId")

        # The type of transaction. For example, "Disbursed to Amazon Gift Card balance".
        attribute?(:transaction_type, String, from: "TransactionType")
      end
    end
  end
end
