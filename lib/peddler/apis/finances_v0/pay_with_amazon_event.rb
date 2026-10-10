# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # An event related to the seller's Pay with Amazon account.
      PayWithAmazonEvent = Structure.new do
        # A short description of this payment event.
        attribute?(:amount_description, String, from: "AmountDescription")

        # The type of business object.
        attribute?(:business_object_type, String, from: "BusinessObjectType")

        # The charge associated with the event.
        attribute?(:charge, ChargeComponent, from: "Charge")

        # A list of fees associated with the event.
        attribute?(:fee_list, [FeeComponent], from: "FeeList")

        # The fulfillment channel.
        #
        # Possible values:
        #
        # * `AFN`: Amazon Fulfillment Network (Fulfillment by Amazon)
        #
        # * `MFN`: Merchant Fulfillment Network (self-fulfilled)
        attribute?(:fulfillment_channel, String, from: "FulfillmentChannel")

        # The type of payment.
        #
        # Possible values:
        #
        # * `Sales`
        attribute?(:payment_amount_type, String, from: "PaymentAmountType")

        # The sales channel for the transaction.
        attribute?(:sales_channel, String, from: "SalesChannel")

        # An order identifier that is specified by the seller.
        attribute?(:seller_order_id, String, from: "SellerOrderId")

        # The name of the store where the event occurred.
        attribute?(:store_name, String, from: "StoreName")

        # The date and time when the payment transaction is posted. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format.
        attribute?(:transaction_posted_date, String, from: "TransactionPostedDate")
      end
    end
  end
end
