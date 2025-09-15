# frozen_string_literal: true

require "peddler/types/finances_v0/currency"

module Peddler
  module Types
    module FinancesV0
      # An event linked to the payment of a fee related to the specified deal.
      SellerDealPaymentEvent = Structure.new do
        # @return [String] The date and time when the financial event was posted.
        attribute(:posted_date, String, from: "postedDate")

        # @return [String] The unique identifier of the deal.
        attribute(:deal_id, String, from: "dealId")

        # @return [String] The internal description of the deal.
        attribute(:deal_description, String, from: "dealDescription")

        # @return [String] The type of event: SellerDealComplete.
        attribute(:event_type, String, from: "eventType")

        # @return [String] The type of fee: RunLightningDealFee.
        attribute(:fee_type, String, from: "feeType")

        # @return [Currency] The monetary amount of the fee.
        attribute(:fee_amount, Currency, from: "feeAmount")

        # @return [Currency] The monetary amount of the tax applied.
        attribute(:tax_amount, Currency, from: "taxAmount")

        # @return [Currency] The total monetary amount paid.
        attribute(:total_amount, Currency, from: "totalAmount")
      end
    end
  end
end
