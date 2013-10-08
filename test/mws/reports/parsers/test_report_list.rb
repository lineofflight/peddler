require 'parser_helper'
require 'mws/reports/parsers/report_list'

class ReportListParserTest < ParserTest
  def setup
    node = fixture('reports/report_list').xpath('//xmlns:GetReportListResult')
    @list = MWS::Reports::Parsers::ReportList.new(node)
  end

  def test_has_report_list
    refute_empty @list.to_a
    @list.each { |report| assert_kind_of MWS::Reports::Parsers::ReportInfo, report }
  end

  def test_has_token
    assert @list.has_next_token?
  end
end
