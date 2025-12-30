# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # An EBT refund reimbursement event.
      EBTRefundReimbursementOnlyEvent = Structure.new do
        # @return [Money] The amount reimbursed during this event.
        attribute?(:amount, Money, from: "Amount")

        # @return [String] The identifier of an order.
        attribute?(:order_id, String, from: "OrderId")

        # @return [String] The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")
      end
    end
  end
end
