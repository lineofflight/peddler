require 'mws/reports/requests/report_request_list'
require 'mws/reports/requests/report_request_count'
require 'mws/reports/requests/report_requests'
require 'peddler/client'

module MWS
  module Reports
    class Client < ::Peddler::Client
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
      # Returns an enumerable report request List.
      def_delegator :report_request_list, :get, :get_report_request_list

      # Public: List the next page of the list of report requests.
      #
      # Examples
      #
      #   client.get_report_request_list_by_next_token
      #
      # Returns an enumerable report request List.
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

      private

      def report_request_list
        @report_request_list ||= Requests::ReportRequestList.new(self)
      end

      def report_request_count
        @report_request_count ||= Requests::ReportRequestCount.new(self)
      end

      def report_requests
        @report_requests ||= Requests::ReportRequests.new(self)
      end
    end
  end
end
