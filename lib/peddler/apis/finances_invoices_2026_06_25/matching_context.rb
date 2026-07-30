# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesInvoices20260625
      # How an invoice line item's quantity and price were matched against expected values, including any variances and
      # their underlying reasons.
      MatchingContext = Structure.new do
        # @return [Money] The monetary amount that was matched.
        attribute(:matched_amount, Money, null: false, from: "matchedAmount")

        # @return [Integer] The quantity that was matched.
        attribute(:matched_quantity, Integer, null: false, from: "matchedQuantity")

        # @return [Money] The monetary amount that has been paid.
        attribute?(:paid_amount, Money, from: "paidAmount")

        # @return [Integer] The quantity that has been paid for.
        attribute?(:paid_quantity, Integer, from: "paidQuantity")

        # @return [Money] The difference between expected and actual price.
        attribute?(:price_variance, Money, from: "priceVariance")

        # @return [Integer] The difference between expected and actual quantity.
        attribute?(:quantity_variance, Integer, from: "quantityVariance")

        # @return [Array<VarianceReason>] Reasons for the variance.
        attribute?(:variance_reasons, [VarianceReason], from: "varianceReasons")
      end
    end
  end
end
