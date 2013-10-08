require 'mws/reports/requests/report_request_list'
require 'mws/reports/requests/report_request_count'
require 'mws/reports/requests/report_requests'
require 'mws/reports/requests/report_list'
require 'mws/reports/requests/report_count'
require 'mws/reports/requests/report'
require 'peddler/client'

module MWS
  module Reports
    class Client < ::Peddler::Client
      # Public: Create a report request.
      #
      # type    - The String type of report to request.
      # options - The Hash query parameters used to narrow the list. Refer to
      #           the MWS Reports API for available parameters.
      #
      # Examples
      #
      #   client.request_report('_GET_ORDERS_DATA_')
      #
      # Returns the Report Request Info.
      def_delegator :report_request_info, :request, :request_report

      # Public: Get a list of report requests submitted during a specified time
      # frame.
      #
      # options - The Hash query parameters used to narrow the list. Refer to
      #           the MWS Reports API for available parameters.
      #
      # Examples
      #
      #   client.get_report_request_list(submitted_from_date: 1.week.ago)
      #
      # Returns an enumerable Report Request List.
      def_delegator :report_request_list, :get, :get_report_request_list

      # Public: List the next page of the list of report requests.
      #
      # token - A String token (default: The token returned in the last
      #         request).
      #
      # Examples
      #
      #   client.get_report_request_list_by_next_token
      #
      # Returns an enumerable Report Request List.
      def_delegator :report_request_list, :get_by_next_token, :get_report_request_list_by_next_token

      # Public: Returns a count of the reports requested during a specified time
      # frame.
      #
      # options - The Hash query parameters used to narrow the list. Refer to
      #           the MWS Reports API for available parameters.
      #
      # Examples
      #
      #   client.get_report_request_count(submitted_from_date: 1.week.ago)
      #
      # Returns the Report Request Count.
      def_delegator :report_request_count, :get, :get_report_request_count

      # Public: Cancel one or more report requests.
      #
      # options - The Hash query parameters used to narrow the list. Refer to
      #           the MWS Reports API for available parameters.
      #
      # Returns the canceled report requests and their count.
      def_delegator :report_requests, :cancel, :cancel_report_requests

      # Public: Get a list of reports created during a specified time frame.
      #
      # options - The Hash query parameters used to narrow the list. Refer to
      #           the MWS Reports API for available parameters.
      #
      # Examples
      #
      #   client.get_report_list
      #
      # Returns an enumerable Report List.
      def_delegator :report_list, :get, :get_report_list

      # Public: List the next page of the list of reports.
      #
      # token - A String token (default: The token returned in the last
      #         request).
      #
      # Examples
      #
      #   client.get_report_list_by_next_token
      #
      # Returns an enumerable Report List.
      def_delegator :report_list, :get_by_next_token, :get_report_list_by_next_token

      # Public: Get a count of the reports created during a specified time
      # frame, with a status of _DONE_ and that are available for download.
      #
      # options - The Hash query parameters used to narrow the list. Refer to
      #           the MWS Reports API for available parameters.
      #
      # Examples
      #
      def report
        @report ||= Requests::Report.new(self)
      end

      #   client.get_report_count
      #
      # Returns a Report Count.
      def_delegator :report_count, :get, :get_report_count

      # Public: Get the contents of a report and the Content-MD5 header for the
      # returned report body.
      #
      # id - The String generated report id.
      #
      # Returns a Report.
      def_delegator :report, :get, :get_report

      private

      def report_request_info
        @report_request_info ||= Requests::ReportRequestInfo.new(self)
      end

      def report_request_list
        @report_request_list ||= Requests::ReportRequestList.new(self)
      end

      def report_request_count
        @report_request_count ||= Requests::ReportRequestCount.new(self)
      end

      def report_requests
        @report_requests ||= Requests::ReportRequests.new(self)
      end

      def report_list
        @report_list ||= Requests::ReportList.new(self)
      end

      def report_count
        @report_count ||= Requests::ReportCount.new(self)
      end

      def report
        @report ||= Requests::Report.new(self)
      end
    end
  end
end
