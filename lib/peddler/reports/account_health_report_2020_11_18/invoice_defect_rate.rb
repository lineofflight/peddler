# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module AccountHealthReport20201118
      # Seller's invoice defect rate within a given reporting date range for 1 requested marketplace.
      InvoiceDefectRate = Structure.new do
        # Total invoice defects count due to missing invoice and late invoice.
        attribute(:invoice_defect, InvoiceDefect, null: false, from: "invoiceDefect")

        # Total late invoice count in the time window.
        attribute(:late_invoice, LateInvoice, null: false, from: "lateInvoice")

        # Total missing invoice count in the time window.
        attribute(:missing_invoice, MissingInvoice, null: false, from: "missingInvoice")

        attribute(:order_count, String, null: false, from: "orderCount")

        attribute(:rate, String, null: false)

        attribute(:reporting_date_range, ReportingDateRange, null: false, from: "reportingDateRange")

        attribute(:status, String, null: false)

        attribute(:target_condition, String, null: false, from: "targetCondition")

        attribute(:target_value, String, null: false, from: "targetValue")
      end
    end
  end
end
