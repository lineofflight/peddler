require 'parser_helper'
require 'mws/reports/parsers/report_request_count'

class ReportRequestCountParserTest < ParserTest
  def setup
    node = fixture('reports/report_request_count').xpath('//xmlns:GetReportRequestCountResult')
    @request = MWS::Reports::Parsers::ReportRequestCount.new(node)
  end

  def test_report_request_count
    assert_kind_of Integer, @request.count
  end
end
