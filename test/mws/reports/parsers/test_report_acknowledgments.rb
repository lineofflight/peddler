require 'parser_helper'
require 'mws/reports/parsers/report_acknowledgements'

class ReportAcknowledgementsParserTest < ParserTest
  def setup
    node = fixture('reports/report_acknowledgements').xpath('//xmlns:UpdateReportAcknowledgementsResult')
    @acknowledgments = MWS::Reports::Parsers::ReportAcknowledgements.new(node)
  end

  def test_has_report_acknowledgements
    refute_empty @acknowledgments.to_a
    @acknowledgments.each { |ack| assert_kind_of MWS::Reports::Parsers::ReportInfo, ack }
  end
end
