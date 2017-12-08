# frozen_string_literal: true

require 'integration_helper'
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

  def test_gets_report
    clients.each do |client|
      res = client.get_report_list(max_count: 1)
      id = res.parse['ReportInfo']['ReportId']
      res = client.get_report(id)
      assert res.valid?
      refute_empty res.parse || res.records_count
    end
  end
end
