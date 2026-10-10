# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # An EBT refund reimbursement event.
      EBTRefundReimbursementOnlyEvent = Structure.new do
        # The amount reimbursed during this event.
        attribute?(:amount, Money, from: "Amount")

        # The identifier of an order.
        attribute?(:order_id, String, from: "OrderId")

        # The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")
      end
    end
  end
end
