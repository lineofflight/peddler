# frozen_string_literal: true

require "peddler/types/finances_v0/currency"

module Peddler
  module Types
    module FinancesV0
      # A loan advance, loan payment, or loan refund.
      LoanServicingEvent = Structure.new do
        # @return [Currency] The amount of the loan.
        attribute(:loan_amount, Currency, from: "LoanAmount")

        # @return [String] The type of event.
        #
        # Possible values:
        #
        # * LoanAdvance
        #
        # * LoanPayment
        #
        # * LoanRefund
        attribute(:source_business_event_type, String, from: "SourceBusinessEventType")
      end
    end
  end
end
