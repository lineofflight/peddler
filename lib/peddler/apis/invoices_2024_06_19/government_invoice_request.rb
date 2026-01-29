# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Invoices20240619
      # Information required to create the government invoice.
      GovernmentInvoiceRequest = Structure.new do
        # @return [String] Marketplace specific classification of the invoice type. Check 'invoiceType' options using
        #   'getInvoicesAttributes' operation.
        attribute(:invoice_type, String, from: "invoiceType")

        # @return [String] The government invoices creation request will match the national authoritative source of the
        #   given marketplace.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] The unique shipment identifier to get an invoice for.
        attribute(:shipment_id, String, from: "shipmentId")

        # @return [String] Marketplace specific classification of the transaction type that originated the invoice.
        #   Check 'transactionType' options using 'getInvoicesAttributes' operation.
        attribute(:transaction_type, String, from: "transactionType")

        # @return [Array<CarrierDetailsContext>] Object that contains additional invoice creation information
        attribute?(:contexts, [CarrierDetailsContext])

        # @return [String] The unique InboundPlan identifier in which the shipment is contained and for which the
        #   invoice will be created.
        attribute?(:inbound_plan_id, String, from: "inboundPlanId")
      end
    end
  end
end
