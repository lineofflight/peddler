# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # An event linked to the payment of a fee related to the specified deal.
      SellerDealPaymentEvent = Structure.new do
        # @return [String] The internal description of the deal.
        attribute?(:deal_description, String, from: "dealDescription")

        # @return [String] The unique identifier of the deal.
        attribute?(:deal_id, String, from: "dealId")

        # @return [String] The type of event: `SellerDealComplete`.
        attribute?(:event_type, String, from: "eventType")

        # @return [Money] The monetary amount of the fee.
        attribute?(:fee_amount, Money, from: "feeAmount")

        # @return [String] The type of fee: `RunLightningDealFee`.
        attribute?(:fee_type, String, from: "feeType")

        # @return [String] The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "postedDate")

        # @return [Money] The monetary amount of the tax applied.
        attribute?(:tax_amount, Money, from: "taxAmount")

        # @return [Money] The total monetary amount paid.
        attribute?(:total_amount, Money, from: "totalAmount")
      end
    end
  end
end
