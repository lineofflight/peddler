require 'integration_helper'
require 'mws/reports'

class ReportScheduleCountTest < IntegrationTest
  self.api = MWS::Reports

  def test_gets_report_schedule_count
    @clients.each do |client|
      res = client.get_report_schedule_count
      assert_kind_of Integer, res.count
    end
  end
end
