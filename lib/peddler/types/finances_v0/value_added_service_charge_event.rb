# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/finances_v0/currency"

module Peddler
  module Types
    module FinancesV0
      # An event related to a value added service charge.
      ValueAddedServiceChargeEvent = Structure.new do
        # @return [String] Indicates the type of transaction.
        #
        # Example: 'Other Support Service fees'
        attribute(:transaction_type, String, from: "TransactionType")

        # @return [String] The date and time when the financial event was posted.
        attribute(:posted_date, String, from: "PostedDate")

        # @return [String] A short description of the service charge event.
        attribute(:description, String, from: "Description")

        # @return [Currency] The amount of the service charge event.
        attribute(:transaction_amount, Currency, from: "TransactionAmount")
      end
    end
  end
end
