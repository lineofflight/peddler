require 'parser_helper'
require 'mws/reports/parsers/report_schedule_count'

class ReportScheduleCountParserTest < ParserTest
  def setup
    node = fixture('reports/report_schedule_count').xpath('//xmlns:GetReportScheduleCountResult')
    @counter = MWS::Reports::Parsers::ReportScheduleCount.new(node)
  end

  def test_report_schedule_count
    assert_kind_of Integer, @counter.to_i
  end
end
