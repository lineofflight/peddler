# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

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

        # @return [Types::Money] The monetary amount of the fee.
        attribute(:fee_amount, Types::Money, from: "feeAmount")

        # @return [Types::Money] The monetary amount of the tax applied.
        attribute(:tax_amount, Types::Money, from: "taxAmount")

        # @return [Types::Money] The total monetary amount paid.
        attribute(:total_amount, Types::Money, from: "totalAmount")
      end
    end
  end
end
