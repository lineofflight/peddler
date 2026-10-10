# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Notifications
    module TaxInvoiceIssuanceStatus
      # Notification payload data
      Payload = Structure.new do
        # The date and time the invoice was issued. Values are in ISO 8601 date-time format.
        attribute(:date, Time, null: false)

        # The invoice identifier used by an external party, typically the government agency that authorized the invoice.
        attribute(:invoice_id, String, null: false, from: "invoiceId")

        # The identifier for the Amazon store where the invoice was issued.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # The status of the tax invoice issuance.
        attribute(:status, String, null: false)

        # Error details when the invoice issuance fails. Only present for error statuses.
        attribute?(:error, Hash)

        # The order identifier associated with the invoice.
        attribute?(:order_id, String, from: "orderId")
      end
    end
  end
end
