# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module Reports20210630
      # Detailed information about the report.
      Report = Structure.new do
        # The date and time when the report was created.
        attribute(:created_time, Time, null: false, from: "createdTime")

        # The processing status of the report.
        attribute(:processing_status, String, null: false, from: "processingStatus")

        # The identifier for the report. This identifier is unique only in combination with a seller ID.
        attribute(:report_id, String, null: false, from: "reportId")

        # The report type. Refer to [Report Type
        # Values](https://developer-docs.amazon.com/sp-api/docs/report-type-values) for more information.
        attribute(:report_type, String, null: false, from: "reportType")

        # The end of a date and time range used for selecting the data to report.
        attribute?(:data_end_time, Time, from: "dataEndTime")

        # The start of a date and time range used for selecting the data to report.
        attribute?(:data_start_time, Time, from: "dataStartTime")

        # A list of marketplace identifiers for the report.
        attribute?(:marketplace_ids, [String], from: "marketplaceIds")

        # The date and time when the report processing completed, in [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format.
        attribute?(:processing_end_time, Time, from: "processingEndTime")

        # The date and time when the report processing started, in [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format.
        attribute?(:processing_start_time, Time, from: "processingStartTime")

        # The identifier for the report document. Pass this into the `getReportDocument` operation to get the
        # information you will need to retrieve the report document's contents.
        attribute?(:report_document_id, String, from: "reportDocumentId")

        # The identifier of the report schedule that created this report (if any). This identifier is unique only in
        # combination with a seller ID.
        attribute?(:report_schedule_id, String, from: "reportScheduleId")
      end
    end
  end
end
