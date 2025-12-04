# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Finances20240619
      # Additional information related to payments-related transactions.
      PaymentsContext = Structure.new do
        # @return [String] The date of the payment.
        attribute?(:payment_date, String, from: "paymentDate")

        # @return [String] The method of payment.
        attribute?(:payment_method, String, from: "paymentMethod")

        # @return [String] The reference number of the payment.
        attribute?(:payment_reference, String, from: "paymentReference")

        # @return [String] The type of payment.
        attribute?(:payment_type, String, from: "paymentType")
      end
    end
  end
end
