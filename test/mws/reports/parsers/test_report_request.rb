require 'parser_helper'
require 'mws/reports/parsers/report_request'

class ReportRequestParserTest < ParserTest
  def setup
    node = fixture('reports/report_request_list').xpath('//xmlns:GetReportRequestListResult')
    @request = MWS::Reports::Parsers::ReportRequest.new(node)
  end

  def test_report_request_info
    refute_nil @request.info
  end
end
