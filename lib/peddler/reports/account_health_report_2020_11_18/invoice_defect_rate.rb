# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module AccountHealthReport20201118
      # Seller's invoice defect rate within a given reporting date range for 1 requested marketplace.
      InvoiceDefectRate = Structure.new do
        # @return [InvoiceDefect] Total invoice defects count due to missing invoice and late invoice.
        attribute(:invoice_defect, InvoiceDefect, null: false, from: "invoiceDefect")

        # @return [LateInvoice] Total late invoice count in the time window.
        attribute(:late_invoice, LateInvoice, null: false, from: "lateInvoice")

        # @return [MissingInvoice] Total missing invoice count in the time window.
        attribute(:missing_invoice, MissingInvoice, null: false, from: "missingInvoice")

        # @return [String]
        attribute(:order_count, String, null: false, from: "orderCount")

        # @return [String]
        attribute(:rate, String, null: false)

        # @return [ReportingDateRange]
        attribute(:reporting_date_range, ReportingDateRange, null: false, from: "reportingDateRange")

        # @return [String]
        attribute(:status, String, null: false)

        # @return [String]
        attribute(:target_condition, String, null: false, from: "targetCondition")

        # @return [String]
        attribute(:target_value, String, null: false, from: "targetValue")
      end
    end
  end
end
