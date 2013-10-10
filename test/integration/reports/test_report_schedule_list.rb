require 'integration_helper'
require 'mws/reports'

class ReportScheduleListTest < IntegrationTest
  self.api = MWS::Reports

  def test_lists_report_schedules
    @clients.each do |client|
      res = client.get_report_schedule_list
      assert res.count > 0
    end
  end
end
