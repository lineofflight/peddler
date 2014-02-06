require 'integration_helper'
require 'mws/reports'

class ReportsTest < IntegrationTest
  self.api = MWS::Reports

  def test_gets_report_request_count
    VCR.use_cassette('reports/gets_report_request_count') do
      @clients.each do |client|
        res = client.get_report_request_count
        assert_kind_of Integer, res.count
      end
    end
  end

  def test_gets_report_request_list
    VCR.use_cassette('reports/gets_report_request_list') do
      @clients.each do |client|
        requests = client.get_report_request_list
        refute_empty requests.to_a
        more_requests = client.get_report_request_list_by_next_token
        refute_empty more_requests.to_a
        some_more_requests = client.get_report_request_list_by_next_token(more_requests.next_token)
        refute_empty some_more_requests.to_a
      end
    end
  end

  def test_gets_report_schedule_count
    VCR.use_cassette('reports/gets_report_schedule_count') do
      @clients.each do |client|
        res = client.get_report_schedule_count
        assert_kind_of Integer, res.count
      end
    end
  end

  def test_lists_report_schedules
    VCR.use_cassette('reports/lists_report_schedules') do
      @clients.each do |client|
        res = client.get_report_schedule_list
        assert_kind_of Integer, res.count
      end
    end
  end

  def test_manages_report_schedule
    VCR.use_cassette('reports/manages_report_schedule') do
      type = '_GET_FLAT_FILE_ORDERS_DATA_'
      @clients.each do |client|
        client.manage_report_schedule(type, '_1_DAY_')
        res = client.delete_report_schedule(type)
        assert res.count > 0
      end
    end
  end

  def test_gets_report_count
    skip('Some marketplaces return an Internal Error')
    VCR.use_cassette('reports/gets_report_count') do
      @clients.shuffle.each do |client|
        res = client.get_report_count
        assert_kind_of Integer, res.count
      end
    end
  end

  def test_gets_report_list
    VCR.use_cassette('reports/gets_report_list') do
      @clients.each do |client|
        reports = client.get_report_list
        refute_empty reports.to_a
        more_reports = client.get_report_list_by_next_token
        refute_empty more_reports.to_a
        some_more_reports = client.get_report_list_by_next_token(more_reports.next_token)
        refute_empty some_more_reports.to_a
      end
    end
  end

  def test_gets_report
    VCR.use_cassette('reports/gets_report') do
      @clients.each do |client|
        reports = client.get_report_list
        id = reports.to_a.first.id
        report = client.get_report(id)
        refute_empty report.document
      end
    end
  end
end
