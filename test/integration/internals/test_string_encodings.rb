# frozen_string_literal: true

require 'integration_helper'
require 'mws/reports'

class TestStringEncodings < IntegrationTest
  use 'Reports'

  def setup
    skip unless ENV['LIVE']
    super
  end

  def test_seller_feedback_data
    report_type = '_GET_SELLER_FEEDBACK_DATA_'

    # clients.each do |client|
    #   client.request_report(report_type, start_date: Date.today - 30)
    # end

    clients.each do |client|
      res = client.get_report_list(report_type_list: report_type, max_count: 1)
      id = res.dig('ReportInfo', 'ReportId')
      next unless id

      res = client.get_report(id)
      assert_equal res.content_charset, res.body.encoding
    end
  end

  # https://github.com/hakanensari/peddler/issues/147
  def test_merchant_listings_data
    report_type = '_GET_MERCHANT_LISTINGS_DATA_'

    # clients.each do |client|
    #   client.request_report(report_type)
    # end

    clients.each do |client|
      res = client.get_report_list(report_type_list: report_type, max_count: 1)
      id = res.dig('ReportInfo', 'ReportId')
      next unless id

      res = client.get_report(id)
      assert_equal res.content_charset, res.body.encoding
    end
  end
end
