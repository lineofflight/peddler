# frozen_string_literal: true

require 'integration_helper'
require 'mws/reports'

class TestReportTypes < IntegrationTest
  use 'Reports'

  def setup
    skip unless ENV['LIVE']
    super
  end

  # https://github.com/hakanensari/peddler/issues/151
  def test_xml_browse_tree_data
    report_type = '_GET_XML_BROWSE_TREE_DATA_'

    # clients.each do |client|
    #   client.request_report(report_type)
    # end

    clients.each do |client|
      res = client.get_report_list(report_type_list: report_type, max_count: 1)
      id = res.dig('ReportInfo', 'ReportId')
      next unless id

      res = client.get_report(id)

      assert res.parse
    end
  end
end
