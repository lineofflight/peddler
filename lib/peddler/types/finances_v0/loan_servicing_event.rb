# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

module Peddler
  module Types
    module FinancesV0
      # A loan advance, loan payment, or loan refund.
      LoanServicingEvent = Structure.new do
        # @return [Types::Money] The amount of the loan.
        attribute(:loan_amount, Types::Money, from: "LoanAmount")

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
