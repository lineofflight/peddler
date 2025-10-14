# frozen_string_literal: true

require "helper"

module Peddler
  module Reports
    class VendorRealTimeInventoryTest < Minitest::Test
      include FixtureHelpers

      def setup
        @fixture_data = load_fixture("reports/vendor_real_time_inventory.json")
      end

      def test_report_parsing
        report = VendorRealTimeInventory::Report.parse(@fixture_data)

        assert_kind_of(VendorRealTimeInventory::Report, report)
      end

      def test_report_data
        report = VendorRealTimeInventory::Report.parse(@fixture_data)
        item = report.report_data.sample

        assert_kind_of(VendorRealTimeInventory::ReportData, item)
      end

      def test_report_specification
        report = VendorRealTimeInventory::Report.parse(@fixture_data)

        assert_kind_of(VendorRealTimeInventory::ReportSpecification, report.report_specification)
      end
    end
  end
end
