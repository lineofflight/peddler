# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The attributes related to the payment made from customer to seller for this order.
      PaymentInformation = Structure.new do
        # @return [String] The transaction date of this payment.
        attribute(:payment_date, String, null: false, from: "paymentDate")

        # @return [String] The transaction mode of this payment.
        attribute(:payment_mode, String, null: false, from: "paymentMode")

        # @return [String] The transaction identifier of this payment.
        attribute(:payment_transaction_id, String, null: false, from: "paymentTransactionId")
      end
    end
  end
end
