require 'peddler/client'

module MWS
  module Reports
    # The Reports API lets you request reports about your inventory and orders.
    class Client < ::Peddler::Client
      version '2009-01-01'

      # Creates a report request
      #
      # @see http://docs.developer.amazonservices.com/en_US/reports/Reports_RequestReport.html
      # @param report_type [String]
      # @param opts [Hash]
      # @option opts [String, #iso8601] :start_date
      # @option opts [String, #iso8601] :end_date
      # @option opts [String] :report_options
      # @option opts [Array<String>, String] :marketplace_id_list
      # @return [Peddler::XMLParser]
      def request_report(report_type, opts = {})
        operation('RequestReport')
          .add(opts.update('ReportType' => report_type))
          .structure!('MarketplaceIdList', 'Id')

        run
      end

      # Lists report requests
      #
      # @see http://docs.developer.amazonservices.com/en_US/reports/Reports_GetReportRequestList.html
      # @param opts [Hash]
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
      # @see http://docs.developer.amazonservices.com/en_US/reports/Reports_GetReportRequestListByNextToken.html
      # @param next_token [String]
      # @return [Peddler::XMLParser]
      def get_report_request_list_by_next_token(next_token)
        operation('GetReportRequestListByNextToken')
          .add('NextToken' => next_token)

        run
      end

      # Counts requested reports
      #
      # @see http://docs.developer.amazonservices.com/en_US/reports/Reports_GetReportRequestCount.html
      # @param opts [Hash]
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
      # @see http://docs.developer.amazonservices.com/en_US/reports/Reports_CancelReportRequests.html
      # @param opts [Hash]
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
      # @see http://docs.developer.amazonservices.com/en_US/reports/Reports_GetReportList.html
      # @param opts [Hash]
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
      # @see http://docs.developer.amazonservices.com/en_US/reports/Reports_GetReportListByNextToken.html
      # @param next_token [String]
      # @return [Peddler::XMLParser]
      def get_report_list_by_next_token(next_token)
        operation('GetReportListByNextToken')
          .add('NextToken' => next_token)

        run
      end

      # Counts reports
      #
      # @see http://docs.developer.amazonservices.com/en_US/reports/Reports_GetReportCount.html
      # @param opts [Hash]
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
      # @see http://docs.developer.amazonservices.com/en_US/reports/Reports_GetReport.html
      # @param report_id [String]
      # @return [Peddler::XMLParser] if report is in XML format
      # @return [Peddler::CSVParser] if report is a flat file
      def get_report(report_id, &blk)
        operation('GetReport')
          .add('ReportId' => report_id)

        run(&blk)
      end

      # Creates, updates, or deletes a report request schedule
      #
      # @see http://docs.developer.amazonservices.com/en_US/reports/Reports_ManageReportSchedule.html
      # @param report_type [String]
      # @param schedule [String]
      # @param opts [Hash]
      # @option opts [String, #iso8601] :schedule_date
      # @return [Peddler::XMLParser]
      def manage_report_schedule(report_type, schedule, opts = {})
        operation('ManageReportSchedule')
          .add(opts.update('ReportType' => report_type, 'Schedule' => schedule))

        run
      end

      # List scheduled reports
      #
      # @see http://docs.developer.amazonservices.com/en_US/reports/Reports_GetReportScheduleList.html
      # @param report_type_list [*Array<String>]
      # @return [Peddler::XMLParser]
      def get_report_schedule_list(*report_type_list)
        operation('GetReportScheduleList')
          .add('ReportTypeList' => report_type_list)
          .structure!('ReportTypeList', 'Type')

        run
      end

      # List next page of scheduled reports
      #
      # @see http://docs.developer.amazonservices.com/en_US/reports/Reports_GetReportScheduleListByNextToken.html
      # @raise [NotImplementedError]
      def get_report_schedule_list_by_next_token(*)
        fail NotImplementedError
      end

      # Count scheduled reports
      #
      # @see http://docs.developer.amazonservices.com/en_US/reports/Reports_GetReportScheduleCount.html
      # @param report_type_list [Array<String>]
      # @return [Peddler::XMLParser]
      def get_report_schedule_count(*report_type_list)
        operation('GetReportScheduleCount')
          .add('ReportTypeList' => report_type_list)
          .structure!('ReportTypeList', 'Type')

        run
      end

      # Update acknowledged status of one or more reports
      #
      # @see http://docs.developer.amazonservices.com/en_US/reports/Reports_UpdateReportAcknowledgements.html
      # @param acknowledged [Boolean]
      # @param report_id_list [Array<String>]
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
