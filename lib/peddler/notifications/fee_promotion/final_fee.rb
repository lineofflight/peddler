# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FeePromotion
      FinalFee = Structure.new do
        # @return [Integer]
        attribute(:amount, Integer, null: false, from: "Amount")

        # @return [String]
        attribute(:currency_code, String, null: false, from: "CurrencyCode")
      end
    end
  end
end
