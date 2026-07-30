# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Notifications
    module TaxInvoiceIssuanceStatus
      # Notification payload data
      Payload = Structure.new do
        # @return [Time] The date and time the invoice is issued. Values are in ISO 8601 date-time format.
        attribute(:date, Time, null: false)

        # @return [String] The invoice identifier that is used by an external party. This is typically the government
        #   agency that authorized the invoice.
        attribute(:invoice_id, String, null: false, from: "invoiceId")

        # @return [String] The ID of the marketplace from which invoice was issued.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String] The status of the tax invoice issuance.
        attribute(:status, String, null: false)

        # @return [Hash] Error details when the invoice issuance fails. Only present for error statuses.
        attribute?(:error, Hash)

        # @return [String] The order identifier associated with the invoice.
        attribute?(:order_id, String, from: "orderId")
      end
    end
  end
end
