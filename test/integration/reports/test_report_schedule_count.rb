require 'integration_helper'
require 'mws/reports'

class ReportScheduleCountTest < IntegrationTest
  self.api = MWS::Reports

  def test_gets_report_schedule_count
    VCR.use_cassette('report_schedule_count_test/test_gets_report_schedule_count') do
      @clients.each do |client|
        res = client.get_report_schedule_count
        assert_kind_of Integer, res.count
      end
    end
  end
end
