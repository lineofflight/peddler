# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Reports
    #
    # The Selling Partner API for Reports lets you retrieve and manage a variety of reports that can help selling
    # partners manage their businesses.
    class Reports20210630 < API
      # Returns report details for the reports that match the filters that you specify.
      #
      # @param [Array<String>] report_types A list of report types used to filter reports. Refer to [Report Type
      #   Values](https://developer-docs.amazon.com/sp-api/docs/report-type-values) for more information. When
      #   reportTypes is provided, the other filter parameters (processingStatuses, marketplaceIds, createdSince,
      #   createdUntil) and pageSize may also be provided. Either reportTypes or nextToken is required.
      # @param [Array<String>] processing_statuses A list of processing statuses used to filter reports.
      # @param [Array<String>] marketplace_ids A list of marketplace identifiers used to filter reports. The reports
      #   returned will match at least one of the marketplaces that you specify.
      # @param [Integer] page_size The maximum number of reports to return in a single call.
      # @param [String] created_since The earliest report creation date and time for reports to include in the response,
      #   in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format. The default is 90 days
      #   ago. Reports are retained for a maximum of 90 days.
      # @param [String] created_until The latest report creation date and time for reports to include in the response,
      #   in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format. The default is now.
      # @param [String] next_token A string token returned in the response to your previous request. `nextToken` is
      #   returned when the number of results exceeds the specified `pageSize` value. To get the next page of results,
      #   call the `getReports` operation and include this token as the only parameter. Specifying `nextToken` with any
      #   other parameters will cause the request to fail.
      # @return [Hash] The API response
      def get_reports(report_types: nil, processing_statuses: nil, marketplace_ids: nil, page_size: nil,
        created_since: nil, created_until: nil, next_token: nil)
        cannot_sandbox!

        path = "/reports/2021-06-30/reports"
        params = {
          "reportTypes" => report_types,
          "processingStatuses" => processing_statuses,
          "marketplaceIds" => marketplace_ids,
          "pageSize" => page_size,
          "createdSince" => created_since,
          "createdUntil" => created_until,
          "nextToken" => next_token,
        }.compact

        rate_limit(0.0222).get(path, params:)
      end

      # Creates a report.
      #
      # @param [Hash] body Information required to create the report.
      # @return [Hash] The API response
      def create_report(body)
        cannot_sandbox!

        path = "/reports/2021-06-30/reports"

        rate_limit(0.0167).post(path, body:)
      end

      # Cancels the report that you specify. Only reports with `processingStatus=IN_QUEUE` can be cancelled. Cancelled
      # reports are returned in subsequent calls to the `getReport` and `getReports` operations.
      #
      # @param [String] report_id The identifier for the report. This identifier is unique only in combination with a
      #   seller ID.
      # @return [Hash] The API response
      def cancel_report(report_id)
        cannot_sandbox!

        path = "/reports/2021-06-30/reports/#{report_id}"

        rate_limit(0.0222).delete(path)
      end

      # Returns report details (including the `reportDocumentId`, if available) for the report that you specify.
      #
      # @param [String] report_id The identifier for the report. This identifier is unique only in combination with a
      #   seller ID.
      # @return [Hash] The API response
      def get_report(report_id)
        cannot_sandbox!

        path = "/reports/2021-06-30/reports/#{report_id}"

        rate_limit(2.0).get(path)
      end

      # Returns report schedule details that match the filters that you specify.
      #
      # @param [Array<String>] report_types A list of report types used to filter report schedules. Refer to [Report
      #   Type Values](https://developer-docs.amazon.com/sp-api/docs/report-type-values) for more information.
      # @return [Hash] The API response
      def get_report_schedules(report_types)
        cannot_sandbox!

        path = "/reports/2021-06-30/schedules"
        params = {
          "reportTypes" => report_types,
        }.compact

        rate_limit(0.0222).get(path, params:)
      end

      # Creates a report schedule. If a report schedule with the same report type and marketplace IDs already exists, it
      # will be cancelled and replaced with this one.
      #
      # @param [Hash] body Information required to create the report schedule.
      # @return [Hash] The API response
      def create_report_schedule(body)
        cannot_sandbox!

        path = "/reports/2021-06-30/schedules"

        rate_limit(0.0222).post(path, body:)
      end

      # Cancels the report schedule that you specify.
      #
      # @param [String] report_schedule_id The identifier for the report schedule. This identifier is unique only in
      #   combination with a seller ID.
      # @return [Hash] The API response
      def cancel_report_schedule(report_schedule_id)
        cannot_sandbox!

        path = "/reports/2021-06-30/schedules/#{report_schedule_id}"

        rate_limit(0.0222).delete(path)
      end

      # Returns report schedule details for the report schedule that you specify.
      #
      # @param [String] report_schedule_id The identifier for the report schedule. This identifier is unique only in
      #   combination with a seller ID.
      # @return [Hash] The API response
      def get_report_schedule(report_schedule_id)
        cannot_sandbox!

        path = "/reports/2021-06-30/schedules/#{report_schedule_id}"

        rate_limit(0.0222).get(path)
      end

      # Returns the information required for retrieving a report document's contents.
      #
      # @param [String] report_document_id The identifier for the report document.
      # @return [Hash] The API response
      def get_report_document(report_document_id)
        cannot_sandbox!

        path = "/reports/2021-06-30/documents/#{report_document_id}"

        rate_limit(0.0167).get(path)
      end
    end
  end
end
