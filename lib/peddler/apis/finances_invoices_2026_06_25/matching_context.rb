# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesInvoices20260625
      # How an invoice line item's quantity and price were matched against expected values, including any variances and
      # their underlying reasons.
      MatchingContext = Structure.new do
        # The monetary amount that was matched.
        attribute(:matched_amount, Money, null: false, from: "matchedAmount")

        # The quantity that was matched.
        attribute(:matched_quantity, Integer, null: false, from: "matchedQuantity")

        # The monetary amount that has been paid.
        attribute?(:paid_amount, Money, from: "paidAmount")

        # The quantity that has been paid for.
        attribute?(:paid_quantity, Integer, from: "paidQuantity")

        # The difference between expected and actual price.
        attribute?(:price_variance, Money, from: "priceVariance")

        # The difference between expected and actual quantity.
        attribute?(:quantity_variance, Integer, from: "quantityVariance")

        # Reasons for the variance.
        attribute?(:variance_reasons, [VarianceReason], from: "varianceReasons")
      end
    end
  end
end
