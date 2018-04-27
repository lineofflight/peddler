# frozen_string_literal: true

require 'peddler/client'

module MWS
  module Reports
    # The Reports API lets you request reports about your inventory and orders.
    class Client < ::Peddler::Client
      self.version = '2009-01-01'
      self.path = "/Reports/#{version}"

      # Creates a report request
      #
      # @see https://docs.developer.amazonservices.com/en_US/reports/Reports_RequestReport.html
      # @param [String] report_type
      # @param [Hash] opts
      # @option opts [String, #iso8601] :start_date
      # @option opts [String, #iso8601] :end_date
      # @option opts [String] :report_options
      # @option opts [Array<String>, String] :marketplace_id_list
      # @return [Peddler::XMLParser]
      def request_report(report_type, opts = {})
        operation('RequestReport')
          .add(opts)
          .add('ReportType' => report_type)
          .structure!('MarketplaceIdList', 'Id')

        run
      end

      # Lists report requests
      #
      # @see https://docs.developer.amazonservices.com/en_US/reports/Reports_GetReportRequestList.html
      # @param [Hash] opts
      # @option opts [Array<String>, String] :report_request_id_list
      # @option opts [Array<String>, String] :report_type_list
      # @option opts [Array<String>, String] :report_processing_status_list
      # @option opts [Integer] :max_count
      # @option opts [String, #iso8601] :requested_from_date
      # @option opts [String, #iso8601] :requested_to_date
      # @return [Peddler::XMLParser]
      def get_report_request_list(opts = {})
        operation('GetReportRequestList')
          .add(opts)
          .structure!('ReportRequestIdList', 'Id')
          .structure!('ReportTypeList', 'Type')
          .structure!('ReportProcessingStatusList', 'Status')

        run
      end

      # Lists the next page of the report requests
      #
      # @see https://docs.developer.amazonservices.com/en_US/reports/Reports_GetReportRequestListByNextToken.html
      # @param [String] next_token
      # @return [Peddler::XMLParser]
      def get_report_request_list_by_next_token(next_token)
        operation('GetReportRequestListByNextToken')
          .add('NextToken' => next_token)

        run
      end

      # Counts requested reports
      #
      # @see https://docs.developer.amazonservices.com/en_US/reports/Reports_GetReportRequestCount.html
      # @param [Hash] opts
      # @option opts [Array<String>, String] :report_type_list
      # @option opts [Array<String>, String] :report_processing_status_list
      # @option opts [String, #iso8601] :requested_from_date
      # @option opts [String, #iso8601] :requested_to_date
      # @return [Peddler::XMLParser]
      def get_report_request_count(opts = {})
        operation('GetReportRequestCount')
          .add(opts)
          .structure!('ReportTypeList', 'Type')
          .structure!('ReportProcessingStatusList', 'Status')

        run
      end

      # Cancels one or more report requests
      #
      # @see https://docs.developer.amazonservices.com/en_US/reports/Reports_CancelReportRequests.html
      # @param [Hash] opts
      # @option opts [Array<String>, String] :report_type_list
      # @option opts [Array<String>, String] :report_processing_status_list
      # @option opts [String, #iso8601] :requested_from_date
      # @option opts [String, #iso8601] :requested_to_date
      # @return [Peddler::XMLParser]
      def cancel_report_requests(opts = {})
        operation('CancelReportRequests')
          .add(opts)
          .structure!('ReportTypeList', 'Type')
          .structure!('ReportProcessingStatusList', 'Status')

        run
      end

      # Lists reports
      #
      # @see https://docs.developer.amazonservices.com/en_US/reports/Reports_GetReportList.html
      # @param [Hash] opts
      # @option opts [Integer] :max_count
      # @option opts [Array<String>, String] :report_type_list
      # @option opts [Boolean] :acknowledged
      # @option opts [String, #iso8601] :available_from_date
      # @option opts [String, #iso8601] :available_to_date
      # @option opts [Array<String>, String] :report_request_id_list
      # @return [Peddler::XMLParser]
      def get_report_list(opts = {})
        operation('GetReportList')
          .add(opts)
          .structure!('ReportTypeList', 'Type')
          .structure!('ReportRequestIdList', 'Id')

        run
      end

      # Lists the next page of reports
      #
      # @see https://docs.developer.amazonservices.com/en_US/reports/Reports_GetReportListByNextToken.html
      # @param [String] next_token
      # @return [Peddler::XMLParser]
      def get_report_list_by_next_token(next_token)
        operation('GetReportListByNextToken')
          .add('NextToken' => next_token)

        run
      end

      # Counts reports
      #
      # @see https://docs.developer.amazonservices.com/en_US/reports/Reports_GetReportCount.html
      # @param [Hash] opts
      # @option opts [Array<String>, String] :report_type_list
      # @option opts [Boolean] :acknowledged
      # @option opts [String, #iso8601] :available_from_date
      # @option opts [String, #iso8601] :available_to_date
      # @return [Peddler::XMLParser]
      def get_report_count(opts = {})
        operation('GetReportCount')
          .add(opts)
          .structure!('ReportTypeList', 'Type')

        run
      end

      # Gets a report and its Content-MD5 header
      #
      # @see https://docs.developer.amazonservices.com/en_US/reports/Reports_GetReport.html
      # @param [String] report_id
      # @return [Peddler::XMLParser] if report is in XML format
      # @return [Peddler::FlatFileParser] if report is a flat file
      def get_report(report_id, &blk)
        operation('GetReport')
          .add('ReportId' => report_id)

        run(&blk)
      end

      # Creates, updates, or deletes a report request schedule
      #
      # @see https://docs.developer.amazonservices.com/en_US/reports/Reports_ManageReportSchedule.html
      # @param [String] report_type
      # @param [String] schedule
      # @param [Hash] opts
      # @option opts [String, #iso8601] :schedule_date
      # @return [Peddler::XMLParser]
      def manage_report_schedule(report_type, schedule, opts = {})
        operation('ManageReportSchedule')
          .add(opts)
          .add('ReportType' => report_type, 'Schedule' => schedule)

        run
      end

      # Lists scheduled reports
      #
      # @see https://docs.developer.amazonservices.com/en_US/reports/Reports_GetReportScheduleList.html
      # @param [Array<String>] report_type_list
      # @return [Peddler::XMLParser]
      def get_report_schedule_list(*report_type_list)
        operation('GetReportScheduleList')
          .add('ReportTypeList' => report_type_list)
          .structure!('ReportTypeList', 'Type')

        run
      end

      # Lists next page of scheduled reports
      #
      # @see https://docs.developer.amazonservices.com/en_US/reports/Reports_GetReportScheduleListByNextToken.html
      # @raise [NotImplementedError]
      def get_report_schedule_list_by_next_token(*)
        raise NotImplementedError
      end

      # Counts scheduled reports
      #
      # @see https://docs.developer.amazonservices.com/en_US/reports/Reports_GetReportScheduleCount.html
      # @param [Array<String>] report_type_list
      # @return [Peddler::XMLParser]
      def get_report_schedule_count(*report_type_list)
        operation('GetReportScheduleCount')
          .add('ReportTypeList' => report_type_list)
          .structure!('ReportTypeList', 'Type')

        run
      end

      # Updates acknowledged status of one or more reports
      #
      # @see https://docs.developer.amazonservices.com/en_US/reports/Reports_UpdateReportAcknowledgements.html
      # @param [Boolean] acknowledged
      # @param [Array<String>] report_id_list
      # @return [Peddler::XMLParser]
      def update_report_acknowledgements(acknowledged, *report_id_list)
        operation('UpdateReportAcknowledgements')
          .add('ReportIdList' => report_id_list, 'Acknowledged' => acknowledged)
          .structure!('ReportIdList', 'Id')

        run
      end
    end
  end
end
