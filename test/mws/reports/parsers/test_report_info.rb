require 'parser_helper'
require 'mws/reports/parsers/report_info'

class ReportInfoParserTest < ParserTest
  def setup
    node = fixture('reports/report_list').xpath('//xmlns:ReportInfo').first
    @report = MWS::Reports::Parsers::ReportInfo.new(node)
  end

  def test_id
    assert_kind_of String, @report.id
  end

  def test_type
    assert_kind_of String, @report.type
  end

  def test_request_id
    assert_kind_of String, @report.request_id
  end

  def test_available_at
    assert_kind_of Time, @report.available_at
  end

  def test_acknowledged
    assert [true, false].include?(@report.acknowledged?)
  end
end
