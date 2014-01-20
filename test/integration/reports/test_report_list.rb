require 'integration_helper'
require 'mws/reports'

class ReportListTest < IntegrationTest
  self.api = MWS::Reports

  def test_gets_report_list
    VCR.use_cassette('report_list_test/test_gets_report_list') do
      @clients.each do |client|
        reports = client.get_report_list
        refute_empty reports.to_a
        more_reports = client.get_report_list_by_next_token
        refute_empty more_reports.to_a
        some_more_reports = client.get_report_list_by_next_token(more_reports.next_token)
        refute_empty some_more_reports.to_a
      end
    end
  end
end
