# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Transfers20240601
      # All the information related to a payout.
      Payout = Structure.new do
        # The current status of the payout. This value corresponds to the most recent entry in the `statusHistory` list.
        attribute(:current_status, String, null: false, from: "currentStatus")

        # The unique identifier of the payout.
        attribute(:id, String, null: false)

        # Metadata that describes the selling partner.
        attribute(:partner_metadata, PartnerMetadata, null: false, from: "partnerMetadata")

        # A chronological list of payout status updates.
        attribute(:status_history, [PayoutStatusEntry], null: false, from: "statusHistory")

        # The last few digits of the payment instrument. May be omitted when the configured payment instrument is
        # invalid.
        attribute?(:account_tail, String, from: "accountTail")

        # The total amount of the payout. Can be null when there is no payout amount to disburse.
        attribute?(:amount, Money)

        # The date when the payout was created.
        attribute?(:creation_date, String, from: "creationDate")

        # The type of payout instrument to which funds are delivered.
        attribute?(:payment_method, String, from: "paymentMethod")

        # The underlying payment network or clearing system used to transmit the payout.
        attribute?(:payment_rail, String, from: "paymentRail")

        # The time interval for calculating the payout amount.
        attribute?(:period, Period)

        # Identifiers related to the payout, such as settlement IDs.
        attribute?(:related_identifiers, [RelatedIdentifier], from: "relatedIdentifiers")

        # The banking network's unique identifier for a fund transfer request.
        attribute?(:trace_id, String, from: "traceId")

        # The type of payout. Can be null when there is no payout.
        attribute?(:type, String)
      end
    end
  end
end
