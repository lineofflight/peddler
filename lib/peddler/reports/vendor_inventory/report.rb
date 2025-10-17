# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module VendorInventory
      # This report shares inventory data of a vendor's items both at an aggregated level (across the vendor's entire
      # catalog of items) and at a per-ASIN level. Data is available at different date range aggregation levels: DAY,
      # WEEK, MONTH, QUARTER, YEAR. Requests can span multiple date range periods. For example, if the customer
      # specified reportPeriod=WEEK and a dataStartTime and dataEndTime that are 3 weeks apart, the report would contain
      # data for each of those 3 contiguous weeks.
      Report = Structure.new do
        # @return [Array<InventoryAggregate>]
        attribute(:inventory_aggregate, [InventoryAggregate], from: "inventoryAggregate")

        # @return [Array<InventoryByAsin>]
        attribute(:inventory_by_asin, [InventoryByASIN], from: "inventoryByAsin")

        # @return [Hash] The report summary including a reporting date range, distributor view, selling program, and
        #   last updated date in the input.
        attribute(:report_specification, ReportSpecification, from: "reportSpecification")
      end
    end
  end
end
