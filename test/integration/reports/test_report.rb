require 'integration_helper'
require 'mws/reports'

class ReportTest < IntegrationTest
  self.api = MWS::Reports

  def test_gets_report_list
    @clients.each do |client|
      reports = client.get_report_list
      id = reports.to_a.sample.id
      report = client.get_report(id)
      refute_empty report.document
    end
  end
end
