# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module Promotion
      # Summarizes the original report request.
      ReportSpecification = Structure.new do
        # @return [Array<String>] The marketplace IDs specified in the report request.
        attribute(:marketplace_ids, [String], from: "marketplaceIds")

        # @return [ReportOptions] Report options specifying the parameters promotionStartDateFrom and
        #   promotionStartDateTo.
        attribute(:report_options, ReportOptions, from: "reportOptions")

        # @return [String] The report type.
        attribute(:report_type, String, from: "reportType")
      end
    end
  end
end
