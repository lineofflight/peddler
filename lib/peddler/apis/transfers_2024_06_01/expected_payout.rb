# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Transfers20240601
      # All the information related to an expected payout.
      ExpectedPayout = Structure.new do
        # @return [PartnerMetadata] Metadata that describes the selling partner.
        attribute(:partner_metadata, PartnerMetadata, null: false, from: "partnerMetadata")

        # @return [String] The status of the expected payout.
        attribute(:status, String, null: false)

        # @return [String] The last few digits of the payment instrument.
        attribute?(:account_tail, String, from: "accountTail")

        # @return [Money] The total amount of money expected in the payout. Can be null when no payout is expected
        attribute?(:amount, Money)

        # @return [String] The type of payout instrument to which funds will be delivered.
        attribute?(:payment_method, String, from: "paymentMethod")

        # @return [Period] The interval considered for calculating the payout amount.
        attribute?(:period, Period)

        # @return [Array<RelatedIdentifier>] Identifiers related to the payout, such as settlement IDs.
        attribute?(:related_identifiers, [RelatedIdentifier], from: "relatedIdentifiers")

        # @return [String] The expected date when the payout would be initiated in Amazon's system.
        attribute?(:scheduled_date, String, from: "scheduledDate")
      end
    end
  end
end
