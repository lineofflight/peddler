# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class SellerWallet20240301
      # Request body to initiate a transaction from a Seller Wallet bank account to another customer-defined bank
      # account.
      TransactionInitiationRequest = Structure.new do
        # @return [TransactionInstrumentDetails] Details of the destination bank account in the transaction request.
        attribute(:destination_transaction_instrument, TransactionInstrumentDetails, null: false, from: "destinationTransactionInstrument")

        # @return [Time] The time at which the transaction was initiated in [ISO 8601 date time
        #   format](https://developer-docs.amazon.com/sp-api/docs/iso-8601).
        attribute(:request_time, Time, null: false, from: "requestTime")

        # @return [String] The unique identifier of the source Amazon Seller Wallet bank account from which the money is
        #   debited.
        attribute(:source_account_id, String, null: false, from: "sourceAccountId")

        # @return [Money] The transaction amount in the source account's currency format. Requests that use a currency
        #   other than the source bank account currency fail.
        attribute(:source_amount, Money, null: false, from: "sourceAmount")

        # @return [String] If the payment is for VAT (Value-Added-Tax) then enter VAT identification number in this
        #   field which will be mandatory. The length constraint is 140 characters and do not allow user to enter any
        #   sensitive information other than VAT-ID.
        attribute?(:customer_payment_reference, String, from: "customerPaymentReference")

        # @return [String] The unique identifier of the destination bank account where the money is deposited.
        attribute?(:destination_account_id, String, from: "destinationAccountId")

        # @return [PayeeContactInformation] The contact information of a payee.
        attribute?(:payee_contact_information, PayeeContactInformation, from: "payeeContactInformation")

        # @return [String] A description of the transaction.
        attribute?(:transaction_description, String, from: "transactionDescription")

        # @return [TransferRatePreview] The fees and foreign exchange rates that apply to the transaction. Transfer Rate
        #   Preview is currently optional. This field is required when the third party honors the fees and rates of the
        #   Seller Wallet transaction.
        attribute?(:transfer_rate_details, TransferRatePreview, from: "transferRateDetails")
      end
    end
  end
end
