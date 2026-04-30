# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Orders20260101
      # Payment information about the order.
      OrderPayment = Structure.new do
        # @return [Array<PaymentExecution>] A list of payment executions for the order.
        attribute?(:payment_executions, [PaymentExecution], from: "paymentExecutions")
      end
    end
  end
end
