# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/transfers_2024_06_01/payment_method_details"

module Peddler
  module Types
    module Transfers20240601
      # The response schema for the `getPaymentMethods` operation.
      GetPaymentMethodsResponse = Structure.new do
        # @return [Array<PaymentMethodDetails>]
        attribute?(:payment_methods, [PaymentMethodDetails], from: "paymentMethods")
      end
    end
  end
end
