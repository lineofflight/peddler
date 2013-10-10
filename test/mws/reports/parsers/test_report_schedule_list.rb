require 'parser_helper'
require 'mws/reports/parsers/report_schedule_list'

class ReportScheduleListParserTest < ParserTest
  def setup
    node = fixture('reports/report_schedule_list').xpath('//xmlns:GetReportScheduleListResult')
    @list = MWS::Reports::Parsers::ReportScheduleList.new(node)
  end

  def test_has_report_schedules
    refute_empty @list.to_a
    @list.each { |rs| assert_kind_of MWS::Reports::Parsers::ReportSchedule, rs }
  end

  def test_has_token
    assert @list.has_next_token?
  end
end
