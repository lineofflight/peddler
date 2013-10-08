require 'parser_helper'
require 'mws/reports/parsers/report_count'

class ReportCountParserTest < ParserTest
  def setup
    node = fixture('reports/report_count').xpath('//xmlns:GetReportCountResult')
    @report = MWS::Reports::Parsers::ReportCount.new(node)
  end

  def test_report_count
    assert_kind_of Integer, @report.count
  end
end
