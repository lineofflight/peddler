# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FeePromotion
      FeesEstimateTotalFeesEstimate = Structure.new do
        # @return [Integer]
        attribute(:amount, Integer, from: "Amount")

        # @return [String]
        attribute(:currency_code, String, from: "CurrencyCode")
      end
    end
  end
end
