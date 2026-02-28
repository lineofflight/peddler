# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellingPartnerRepeatPurchase
      # The Repeat Purchase report shares data on the quantity of repeated purchases of the selling partner's items.
      # Data is available at different date range aggregation levels: WEEK, MONTH, QUARTER. Requests can span multiple
      # reporting periods. In this report, "asin" is an ASIN in the selling partner's catalog.
      Report = Structure.new do
        # @return [Array<DataByAsin>]
        attribute(:data_by_asin, [DataByASIN], null: false, from: "dataByAsin")

        # @return [Hash] Summarizes the original report request.
        attribute(:report_specification, ReportSpecification, null: false, from: "reportSpecification")
      end
    end
  end
end
