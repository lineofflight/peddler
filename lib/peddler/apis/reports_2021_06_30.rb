# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Reports
    #
    # The Selling Partner API for Reports lets you retrieve and manage a variety of reports that can help selling
    # partners manage their businesses.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/reports-api-model/reports_2021-06-30.json
    class Reports20210630 < API
      include Peddler::Helpers::Reports20210630

      # Returns report details for the reports that match the filters that you specify.
      #
      # @note This operation can make a static sandbox call.
      # @param report_types [Array<String>] A list of report types used to filter reports. Refer to [Report Type
      #   Values](https://developer-docs.amazon.com/sp-api/docs/report-type-values) for more information. When
      #   reportTypes is provided, the other filter parameters (processingStatuses, marketplaceIds, createdSince,
      #   createdUntil) and pageSize may also be provided. Either reportTypes or nextToken is required.
      # @param processing_statuses [Array<String>] A list of processing statuses used to filter reports.
      # @param marketplace_ids [Array<String>] A list of marketplace identifiers used to filter reports. The reports
      #   returned will match at least one of the marketplaces that you specify.
      # @param page_size [Integer] The maximum number of reports to return in a single call.
      # @param created_since [String] The earliest report creation date and time for reports to include in the response,
      #   in {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} date time format. The default is 90 days
      #   ago. Reports are retained for a maximum of 90 days.
      # @param created_until [String] The latest report creation date and time for reports to include in the response,
      #   in {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} date time format. The default is now.
      # @param next_token [String] A string token returned in the response to your previous request. `nextToken` is
      #   returned when the number of results exceeds the specified `pageSize` value. To get the next page of results,
      #   call the `getReports` operation and include this token as the only parameter. Specifying `nextToken` with any
      #   other parameters will cause the request to fail.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_reports(report_types: nil, processing_statuses: nil, marketplace_ids: nil, page_size: 10,
        created_since: nil, created_until: nil, next_token: nil, rate_limit: 0.0222)
        path = "/reports/2021-06-30/reports"
        params = {
          "reportTypes" => stringify_array(report_types),
          "processingStatuses" => stringify_array(processing_statuses),
          "marketplaceIds" => stringify_array(marketplace_ids),
          "pageSize" => page_size,
          "createdSince" => created_since,
          "createdUntil" => created_until,
          "nextToken" => next_token,
        }.compact
        parser = -> { GetReportsResponse }
        get(path, params:, rate_limit:, parser:)
      end

      # Creates a report.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] Information required to create the report.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_report(body, rate_limit: 0.0167)
        path = "/reports/2021-06-30/reports"
        parser = -> { CreateReportResponse }
        post(path, body:, rate_limit:, parser:)
      end

      # Cancels the report that you specify. Only reports with `processingStatus=IN_QUEUE` can be cancelled. Cancelled
      # reports are returned in subsequent calls to the `getReport` and `getReports` operations.
      #
      # @note This operation can make a static sandbox call.
      # @param report_id [String] The identifier for the report. This identifier is unique only in combination with a
      #   seller ID.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def cancel_report(report_id, rate_limit: 0.0222)
        path = "/reports/2021-06-30/reports/#{percent_encode(report_id)}"
        delete(path, rate_limit:)
      end

      # Returns report details (including the `reportDocumentId`, if available) for the report that you specify.
      #
      # @note This operation can make a static sandbox call.
      # @param report_id [String] The identifier for the report. This identifier is unique only in combination with a
      #   seller ID.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_report(report_id, rate_limit: 2.0)
        path = "/reports/2021-06-30/reports/#{percent_encode(report_id)}"
        parser = -> { Report }
        get(path, rate_limit:, parser:)
      end

      # Returns report schedule details that match the filters that you specify.
      #
      # @note This operation can make a static sandbox call.
      # @param report_types [Array<String>] A list of report types used to filter report schedules. Refer to [Report
      #   Type Values](https://developer-docs.amazon.com/sp-api/docs/report-type-values) for more information.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_report_schedules(report_types, rate_limit: 0.0222)
        path = "/reports/2021-06-30/schedules"
        params = {
          "reportTypes" => stringify_array(report_types),
        }.compact
        parser = -> { ReportScheduleList }
        get(path, params:, rate_limit:, parser:)
      end

      # Creates a report schedule. If a report schedule with the same report type and marketplace IDs already exists, it
      # will be cancelled and replaced with this one.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] Information required to create the report schedule.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_report_schedule(body, rate_limit: 0.0222)
        path = "/reports/2021-06-30/schedules"
        parser = -> { CreateReportScheduleResponse }
        post(path, body:, rate_limit:, parser:)
      end

      # Cancels the report schedule that you specify.
      #
      # @note This operation can make a static sandbox call.
      # @param report_schedule_id [String] The identifier for the report schedule. This identifier is unique only in
      #   combination with a seller ID.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def cancel_report_schedule(report_schedule_id, rate_limit: 0.0222)
        path = "/reports/2021-06-30/schedules/#{percent_encode(report_schedule_id)}"
        delete(path, rate_limit:)
      end

      # Returns report schedule details for the report schedule that you specify.
      #
      # @note This operation can make a static sandbox call.
      # @param report_schedule_id [String] The identifier for the report schedule. This identifier is unique only in
      #   combination with a seller ID.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_report_schedule(report_schedule_id, rate_limit: 0.0222)
        path = "/reports/2021-06-30/schedules/#{percent_encode(report_schedule_id)}"
        parser = -> { ReportSchedule }
        get(path, rate_limit:, parser:)
      end

      # Returns the information required for retrieving a report document's contents.
      #
      # @note This operation can make a static sandbox call.
      # @param report_document_id [String] The identifier for the report document.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_report_document(report_document_id, rate_limit: 0.0167)
        path = "/reports/2021-06-30/documents/#{percent_encode(report_document_id)}"
        parser = -> { ReportDocument }
        get(path, rate_limit:, parser:)
      end
    end
  end
end
