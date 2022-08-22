# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Reports
    #
    # Effective **June 27, 2024**, the Selling Partner API for Reports v2020-09-04 will no longer be available and all
    # calls to it will fail. Integrations that rely on the Reports API must migrate to [Reports
    # v2021-06-30](https://developer-docs.amazon.com/sp-api/docs/reports-api-v2021-06-30-reference) to avoid service
    # disruption.
    class Reports20200904 < API
      # Effective **June 27, 2023**, the `getReports` operation will no longer be available in the Selling Partner API
      # for Reports v2020-09-04 and all calls to it will fail. Integrations that rely on this operation should migrate
      # to [Reports v2021-06-30](https://developer-docs.amazon.com/sp-api/docs/reports-api-v2021-06-30-reference) to
      # avoid service disruption.
      #
      # @param [Array<String>] report_types A list of report types used to filter reports. When reportTypes is provided,
      #   the other filter parameters (processingStatuses, marketplaceIds, createdSince, createdUntil) and pageSize may
      #   also be provided. Either reportTypes or nextToken is required.
      # @param [Array<String>] processing_statuses A list of processing statuses used to filter reports.
      # @param [Array<String>] marketplace_ids A list of marketplace identifiers used to filter reports. The reports
      #   returned will match at least one of the marketplaces that you specify.
      # @param [Integer] page_size The maximum number of reports to return in a single call.
      # @param [String] created_since The earliest report creation date and time for reports to include in the response,
      #   in ISO 8601 date time format. The default is 90 days ago. Reports are retained for a maximum of 90 days.
      # @param [String] created_until The latest report creation date and time for reports to include in the response,
      #   in ISO 8601 date time format. The default is now.
      # @param [String] next_token A string token returned in the response to your previous request. nextToken is
      #   returned when the number of results exceeds the specified pageSize value. To get the next page of results,
      #   call the getReports operation and include this token as the only parameter. Specifying nextToken with any
      #   other parameters will cause the request to fail.
      # @return [Hash] The API response
      def get_reports(report_types: nil, processing_statuses: nil, marketplace_ids: nil, page_size: nil,
        created_since: nil, created_until: nil, next_token: nil)
        path = "/reports/2020-09-04/reports"
        params = {
          "reportTypes" => report_types,
          "processingStatuses" => processing_statuses,
          "marketplaceIds" => marketplace_ids,
          "pageSize" => page_size,
          "createdSince" => created_since,
          "createdUntil" => created_until,
          "nextToken" => next_token,
        }.compact

        get(path, params:)
      end

      # Effective **June 27, 2023**, the `createReport` operation will no longer be available in the Selling Partner API
      # for Reports v2020-09-04 and all calls to it will fail. Integrations that rely on this operation should migrate
      # to [Reports v2021-06-30](https://developer-docs.amazon.com/sp-api/docs/reports-api-v2021-06-30-reference) to
      # avoid service disruption.
      #
      # @param [Hash] body
      # @return [Hash] The API response
      def create_report(body)
        path = "/reports/2020-09-04/reports"
        body = body

        post(path, body:)
      end

      # Effective **June 27, 2023**, the `getReport` operation will no longer be available in the Selling Partner API
      # for Reports v2020-09-04 and all calls to it will fail. Integrations that rely on this operation should migrate
      # to [Reports v2021-06-30](https://developer-docs.amazon.com/sp-api/docs/reports-api-v2021-06-30-reference) to
      # avoid service disruption.
      #
      # @param [String] report_id The identifier for the report. This identifier is unique only in combination with a
      #   seller ID.
      # @return [Hash] The API response
      def get_report(report_id)
        path = "/reports/2020-09-04/reports/#{report_id}"

        get(path)
      end

      # Effective **June 27, 2023**, the `cancelReport` operation will no longer be available in the Selling Partner API
      # for Reports v2020-09-04 and all calls to it will fail. Integrations that rely on this operation should migrate
      # to [Reports v2021-06-30](https://developer-docs.amazon.com/sp-api/docs/reports-api-v2021-06-30-reference) to
      # avoid service disruption.
      #
      # @param [String] report_id The identifier for the report. This identifier is unique only in combination with a
      #   seller ID.
      # @return [Hash] The API response
      def cancel_report(report_id)
        path = "/reports/2020-09-04/reports/##{report_id}"

        delete(path)
      end

      # Effective **June 27, 2023**, the `getReportSchedules` operation will no longer be available in the Selling
      # Partner API for Reports v2020-09-04 and all calls to it will fail. Integrations that rely on this operation
      # should migrate to [Reports
      # v2021-06-30](https://developer-docs.amazon.com/sp-api/docs/reports-api-v2021-06-30-reference) to avoid service
      # disruption.
      #
      # @param [Array<String>] report_types A list of report types used to filter report schedules.
      # @return [Hash] The API response
      def get_report_schedules(report_types)
        path = "/reports/2020-09-04/schedules"
        params = {
          "reportTypes" => report_types,
        }.compact

        get(path, params:)
      end

      # Effective **June 27, 2023**, the `createReportSchedule` operation will no longer be available in the Selling
      # Partner API for Reports v2020-09-04 and all calls to it will fail. Integrations that rely on this operation
      # should migrate to [Reports
      # v2021-06-30](https://developer-docs.amazon.com/sp-api/docs/reports-api-v2021-06-30-reference) to avoid service
      # disruption.
      #
      # @param [Hash] body
      # @return [Hash] The API response
      def create_report_schedule(body)
        path = "/reports/2020-09-04/schedules"
        body = body

        post(path, body:)
      end

      # Effective **June 27, 2023**, the `getReportSchedule` operation will no longer be available in the Selling
      # Partner API for Reports v2020-09-04 and all calls to it will fail. Integrations that rely on this operation
      # should migrate to [Reports
      # v2021-06-30](https://developer-docs.amazon.com/sp-api/docs/reports-api-v2021-06-30-reference) to avoid service
      # disruption.
      #
      # @param [String] report_schedule_id The identifier for the report schedule. This identifier is unique only in
      #   combination with a seller ID.
      # @return [Hash] The API response
      def get_report_schedule(report_schedule_id)
        path = "/reports/2020-09-04/schedules/#{report_schedule_id}"

        get(path)
      end

      # Effective **June 27, 2023**, the `cancelReportSchedule` operation will no longer be available in the Selling
      # Partner API for Reports v2020-09-04 and all calls to it will fail. Integrations that rely on this operation
      # should migrate to [Reports
      # v2021-06-30](https://developer-docs.amazon.com/sp-api/docs/reports-api-v2021-06-30-reference) to avoid service
      # disruption.
      #
      # @param [String] report_schedule_id The identifier for the report schedule. This identifier is unique only in
      #   combination with a seller ID.
      # @return [Hash] The API response
      def cancel_report_schedule(report_schedule_id)
        path = "/reports/2020-09-04/schedules/##{report_schedule_id}"

        delete(path)
      end

      # Effective **June 27, 2023**, the `getReportDocument` operation will no longer be available in the Selling
      # Partner API for Reports v2020-09-04 and all calls to it will fail. Integrations that rely on this operation
      # should migrate to [Reports
      # v2021-06-30](https://developer-docs.amazon.com/sp-api/docs/reports-api-v2021-06-30-reference) to avoid service
      # disruption.
      #
      # @param [String] report_document_id The identifier for the report document.
      # @return [Hash] The API response
      def get_report_document(report_document_id)
        path = "/reports/2020-09-04/documents/#{report_document_id}"

        get(path)
      end
    end
  end
end
