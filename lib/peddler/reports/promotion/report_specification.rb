# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module Promotion
      # Summarizes the original report request.
      ReportSpecification = Structure.new do
        # The marketplace IDs specified in the report request.
        attribute(:marketplace_ids, [String], null: false, from: "marketplaceIds")

        # Report options specifying the parameters promotionStartDateFrom and promotionStartDateTo.
        attribute(:report_options, ReportOptions, null: false, from: "reportOptions")

        # The report type.
        attribute(:report_type, String, null: false, from: "reportType")
      end
    end
  end
end
