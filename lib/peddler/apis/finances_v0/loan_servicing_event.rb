# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # A loan advance, loan payment, or loan refund.
      LoanServicingEvent = Structure.new do
        # The amount of the loan.
        attribute?(:loan_amount, Money, from: "LoanAmount")

        # The type of event.
        #
        # Possible values:
        #
        # * `LoanAdvance`
        #
        # * `LoanPayment`
        #
        # * `LoanRefund`
        attribute?(:source_business_event_type, String, from: "SourceBusinessEventType")
      end
    end
  end
end
