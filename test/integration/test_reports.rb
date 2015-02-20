require 'helper'
require 'mws/reports'

class TestReports < IntegrationTest
  def test_gets_report_request_count
    clients.each do |client|
      res = client.get_report_request_count
      refute_empty res.parse
    end
  end

  def test_gets_report_request_list
    clients.each do |client|
      res = client.get_report_request_list
      refute_empty res.parse
    end
  end

  def test_gets_report_schedule_count
    clients.each do |client|
      res = client.get_report_schedule_count
      refute_empty res.parse
    end
  end

  def test_lists_report_schedules
    clients.each do |client|
      res = client.get_report_schedule_list
      refute_empty res.parse
    end
  end

  def test_gets_report_count
    clients.each do |client|
      res = client.get_report_count
      refute_empty res.parse
    end
  end

  def test_gets_report_list
    clients.each do |client|
      res = client.get_report_list
      refute_empty res.parse
    end
  end
end
