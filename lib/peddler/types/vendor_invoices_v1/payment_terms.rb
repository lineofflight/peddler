# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module VendorInvoicesV1
      # Terms of the payment for the invoice. The basis of the payment terms is the invoice date.
      PaymentTerms = Structure.new do
        # @return [String] The payment term type for the invoice.
        attribute?(:type, String)

        # @return [String] The discount percent value, which is good until the discount due date.
        attribute?(:discount_percent, String, from: "discountPercent")

        # @return [Float] The number of calendar days from the Base date (Invoice date) until the discount is no longer
        # valid.
        attribute?(:discount_due_days, Float, from: "discountDueDays")

        # @return [Float] The number of calendar days from the base date (invoice date) until the total amount on the
        # invoice is due.
        attribute?(:net_due_days, Float, from: "netDueDays")
      end
    end
  end
end
