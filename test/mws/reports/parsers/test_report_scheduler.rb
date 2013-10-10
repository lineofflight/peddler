require 'parser_helper'
require 'mws/reports/parsers/report_scheduler'

class ReportSchedulerParserTest < ParserTest
  def setup
    node = fixture('reports/report_scheduler').xpath('//xmlns:ManageReportScheduleResult')
    @scheduler = MWS::Reports::Parsers::ReportScheduler.new(node)
  end

  def test_has_count
    assert_kind_of Integer, @scheduler.count
  end

  def test_has_report_schedule
    assert_kind_of MWS::Reports::Parsers::ReportSchedule, @scheduler.report_schedule
  end
end
