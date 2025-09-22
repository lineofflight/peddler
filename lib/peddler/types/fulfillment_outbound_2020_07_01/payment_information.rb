# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The attributes related to the payment made from customer to seller for this order.
      PaymentInformation = Structure.new do
        # @return [String] The transaction identifier of this payment.
        attribute(:payment_transaction_id, String, from: "paymentTransactionId")

        # @return [String] The transaction mode of this payment.
        attribute(:payment_mode, String, from: "paymentMode")

        # @return [String] The transaction date of this payment.
        attribute(:payment_date, String, from: "paymentDate")
      end
    end
  end
end
