require 'helper'
require 'mws/reports/client'

class TestMWSReportsClient < MiniTest::Test
  def setup
    @client = MWS::Reports::Client.new
  end

  def test_updates_report_acknowledgements
    operation = {
      'Action' => 'UpdateReportAcknowledgements',
      'Acknowledged' => true,
      'ReportIdList.Id.1' => '1'
    }

    @client.stub(:run, nil) do
      @client.update_report_acknowledgements(true, '1')
    end

    assert_equal operation, @client.operation
  end

  # FIXME Fill in tests for operations
end
