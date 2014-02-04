require 'integration_helper'
require 'mws/reports'

class ReportTest < IntegrationTest
  self.api = MWS::Reports

  def test_gets_report_list
    VCR.use_cassette('report_test/test_gets_report_list') do
      @clients.each do |client|
        reports = client.get_report_list
        id = reports.to_a.first.id
        report = client.get_report(id)
        refute_empty report.document
      end
    end
  end
end
