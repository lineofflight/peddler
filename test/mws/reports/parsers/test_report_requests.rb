require 'parser_helper'
require 'mws/reports/parsers/report_requests'

class ReportRequestsParserTest < ParserTest
  def setup
    node = fixture('reports/report_requests').xpath('//xmlns:CancelReportRequestsResult')
    @cancelations = MWS::Reports::Parsers::ReportRequests.new(node)
  end

  def test_cancelation_count
    assert_kind_of Integer, @cancelations.count
  end

  def test_canceled_report_request_infos
    refute_empty @cancelations.report_request_infos
  end
end
