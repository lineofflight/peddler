# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module Reports20210630
      # Detailed information about the report.
      Report = Structure.new do
        # @return [Array<String>] A list of marketplace identifiers for the report.
        attribute?(:marketplace_ids, [String], from: "marketplaceIds")

        # @return [String] The identifier for the report. This identifier is unique only in combination with a seller
        # ID.
        attribute(:report_id, String, from: "reportId")

        # @return [String] The report type. Refer to [Report Type
        # Values](https://developer-docs.amazon.com/sp-api/docs/report-type-values) for more information.
        attribute(:report_type, String, from: "reportType")

        # @return [String] The start of a date and time range used for selecting the data to report.
        attribute?(:data_start_time, String, from: "dataStartTime")

        # @return [String] The end of a date and time range used for selecting the data to report.
        attribute?(:data_end_time, String, from: "dataEndTime")

        # @return [String] The identifier of the report schedule that created this report (if any). This identifier is
        # unique only in combination with a seller ID.
        attribute?(:report_schedule_id, String, from: "reportScheduleId")

        # @return [String] The date and time when the report was created.
        attribute(:created_time, String, from: "createdTime")

        # @return [String] The processing status of the report.
        attribute(:processing_status, String, from: "processingStatus")

        # @return [String] The date and time when the report processing started, in <a
        # href='https://developer-docs.amazon.com/sp-api/docs/iso-8601'>ISO 8601</a> date time format.
        attribute?(:processing_start_time, String, from: "processingStartTime")

        # @return [String] The date and time when the report processing completed, in <a
        # href='https://developer-docs.amazon.com/sp-api/docs/iso-8601'>ISO 8601</a> date time format.
        attribute?(:processing_end_time, String, from: "processingEndTime")

        # @return [String] The identifier for the report document. Pass this into the `getReportDocument` operation to
        # get the information you will need to retrieve the report document's contents.
        attribute?(:report_document_id, String, from: "reportDocumentId")
      end
    end
  end
end
