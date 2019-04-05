# frozen_string_literal: true

require 'integration_helper'
require 'mws/reports'

class TestStringEncodings < IntegrationTest
  use 'Reports'

  def setup
    skip unless ENV['LIVE']
  end

  def test_flat_file_responses
    get_report('_GET_SELLER_FEEDBACK_DATA_') do |res|
      assert_equal res.content_charset, res.body.encoding
    end
  end

  private

  def get_report(report_type, start_date: Date.today - 30)
    clients.each do |client|
      res = client.request_report(report_type, start_date: start_date)
      report_request_id = res.dig('ReportRequestInfo', 'ReportRequestId')
      loop do
        sleep 15
        res = client.get_report_request_list(report_request_id_list:
                                             report_request_id)
        status = res.dig('ReportRequestInfo', 'ReportProcessingStatus')
        next unless status.include?('_DONE_')

        report_id = res.dig('ReportRequestInfo', 'GeneratedReportId')
        yield client.get_report(report_id)
        break
      end
    end
  end
end
