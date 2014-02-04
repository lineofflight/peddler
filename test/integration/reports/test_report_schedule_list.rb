require 'integration_helper'
require 'mws/reports'

class ReportScheduleListTest < IntegrationTest
  self.api = MWS::Reports

  def test_lists_report_schedules
    VCR.use_cassette('report_schedule_list_test/test_lists_report_schedules') do
      @clients.each do |client|
        res = client.get_report_schedule_list
        #assert res.count > 0
      end
    end
  end
end
