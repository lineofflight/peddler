# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # An event related to a value added service charge.
      ValueAddedServiceChargeEvent = Structure.new do
        # @return [String] A short description of the service charge event.
        attribute?(:description, String, from: "Description")

        # @return [String] The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # @return [Money] The amount of the service charge event.
        attribute?(:transaction_amount, Money, from: "TransactionAmount")

        # @return [String] The transaction type. For example, 'Other Support Service fees'
        attribute?(:transaction_type, String, from: "TransactionType")
      end
    end
  end
end
