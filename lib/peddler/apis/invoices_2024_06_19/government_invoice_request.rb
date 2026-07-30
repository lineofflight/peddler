# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Invoices20240619
      # Information required to create the government invoice.
      GovernmentInvoiceRequest = Structure.new do
        # @return [String] The marketplace-specific classification of the invoice type. Check `invoiceType` options
        #   using the `getInvoicesAttributes` operation.
        attribute(:invoice_type, String, null: false, from: "invoiceType")

        # @return [String] The marketplace of the national authoritative source that will be on the government invoice
        #   creation request.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String] The unique shipment identifier for which to get an invoice.
        attribute(:shipment_id, String, null: false, from: "shipmentId")

        # @return [String] The marketplace-specific classification of the transaction type that originated the invoice.
        #   Check `transactionType` options using the `getInvoicesAttributes` operation.
        attribute(:transaction_type, String, null: false, from: "transactionType")

        # @return [Array<CarrierDetailsContext>] Additional information for invoice creation.
        attribute?(:contexts, [CarrierDetailsContext])

        # @return [String] The unique inbound plan identifier in which the shipment is contained and for which the
        #   invoice will be created.
        attribute?(:inbound_plan_id, String, from: "inboundPlanId")
      end
    end
  end
end
