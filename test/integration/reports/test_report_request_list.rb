require 'integration_helper'
require 'mws/reports'

class ReportRequestListTest < IntegrationTest
  self.api = MWS::Reports

  def test_gets_report_request_list
    @clients.each do |client|
      requests = client.get_report_request_list
      refute_empty requests.to_a
      more_requests = client.get_report_request_list_by_next_token
      refute_empty more_requests.to_a
    end
  end
end
