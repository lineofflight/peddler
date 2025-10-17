# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module VendorForecasting
      # The report input summary which includes the marketplace, selling program, and last updated date.
      ReportSpecification = Structure.new do
        # @return [Date] The date when the report was last updated. Follows the
        #   {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} Date format of YYYY-MM-DD.
        attribute(:last_updated_date, Date, from: "lastUpdatedDate")

        # @return [Array<String>] This parameter must match the marketplaceId of the selling partner account. Each
        #   selling partner account belongs to only one marketplaceId.
        attribute(:marketplace_ids, [String], from: "marketplaceIds")

        # @return [ReportOptions] Report options specifying parameters such as sellingProgram.
        attribute(:report_options, ReportOptions, from: "reportOptions")

        # @return [String] The report type.
        attribute(:report_type, String, from: "reportType")
      end
    end
  end
end
