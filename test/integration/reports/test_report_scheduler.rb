require 'integration_helper'
require 'mws/reports'

class ReportSchedulerTest < IntegrationTest
  self.api = MWS::Reports

  def test_manages_report_schedule
    type = '_GET_FLAT_FILE_ORDERS_DATA_'

    VCR.use_cassette('report_scheduler_test/test_manages_report_schedule') do
      @clients.each do |client|
        client.manage_report_schedule(type, '_1_DAY_')
        res = client.delete_report_schedule(type)
        assert res.count > 0
      end
    end
  end
end
