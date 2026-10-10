# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # An event linked to the payment of a fee related to the specified deal.
      SellerDealPaymentEvent = Structure.new do
        # The internal description of the deal.
        attribute?(:deal_description, String, from: "dealDescription")

        # The unique identifier of the deal.
        attribute?(:deal_id, String, from: "dealId")

        # The type of event: `SellerDealComplete`.
        attribute?(:event_type, String, from: "eventType")

        # The monetary amount of the fee.
        attribute?(:fee_amount, Money, from: "feeAmount")

        # The type of fee: `RunLightningDealFee`.
        attribute?(:fee_type, String, from: "feeType")

        # The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "postedDate")

        # The monetary amount of the tax applied.
        attribute?(:tax_amount, Money, from: "taxAmount")

        # The total monetary amount paid.
        attribute?(:total_amount, Money, from: "totalAmount")
      end
    end
  end
end
