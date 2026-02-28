# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module TransactionUpdate
      # Total amount of transaction.
      TotalAmount = Structure.new do
        # @return [Float] Amount value of transaction.
        attribute(:currency_amount, Float, null: false, from: "CurrencyAmount")

        # @return [String] Currency code of transaction.
        attribute(:currency_code, String, null: false, from: "CurrencyCode")
      end
    end
  end
end
