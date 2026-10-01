# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module TaxInvoiceIssuanceEligibilityStatusChange
      # Notification payload data
      Payload = Structure.new do
        # @return [String] The identifier for the store where the invoice issuance eligibility status applies.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String] The invoice issuance operation available to the seller.
        attribute(:operation, String, null: false)

        # @return [String] The status of the seller invoice issuance operation.
        attribute(:status, String, null: false)

        # @return [Array<Object>] An optional message to describe why the operation is blocked.
        attribute?(:message, Array)
      end
    end
  end
end
