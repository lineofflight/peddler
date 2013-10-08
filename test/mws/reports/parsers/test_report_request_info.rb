require 'parser_helper'
require 'mws/reports/parsers/report_request_info'

class ReportRequestInfoParserTest < ParserTest
  def setup
    node = fixture('reports/report_request_list').xpath('//xmlns:ReportRequestInfo').first
    @request = MWS::Reports::Parsers::ReportRequestInfo.new(node)
  end

  def test_id
    assert_kind_of String, @request.id
  end

  def test_type
    assert_kind_of String, @request.type
  end

  def test_started_at
    assert_kind_of Time, @request.started_at
  end

  def test_ended_at
    assert_kind_of Time, @request.ended_at
  end

  def test_scheduled
    assert [true, false].include?(@request.scheduled?)
  end

  def test_submitted_at
    assert_kind_of Time, @request.submitted_at
  end

  def test_processing_status
    assert_kind_of String, @request.processing_status
  end

  def test_generated_report_id
    assert_kind_of String, @request.generated_report_id
  end

  def test_started_processing_at
    assert_kind_of Time, @request.started_processing_at
  end

  def test_completed_at
    assert_kind_of Time, @request.completed_at
  end
end
