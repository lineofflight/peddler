# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module FinancesInvoices20260625
      # The billing period for an invoice.
      BillingPeriod = Structure.new do
        # The end of the billing period of an invoice. In ISO 8601 format.
        attribute(:end_date, Time, null: false, from: "endDate")

        # The start of the billing period of an invoice. In ISO 8601 format.
        attribute(:start_date, Time, null: false, from: "startDate")
      end
    end
  end
end
