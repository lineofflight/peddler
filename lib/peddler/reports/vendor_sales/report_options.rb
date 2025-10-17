# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module VendorSales
      # Report options specifying parameters such as reportPeriod, distributorView, and sellingProgram.
      ReportOptions = Structure.new do
        # @return [String] The distributor view.
        attribute(:distributor_view, String, from: "distributorView")

        # @return [String] Determines what granularity of data is expected in the report. Valid values are: DAY, WEEK,
        #   MONTH, QUARTER, YEAR.
        attribute(:report_period, String, from: "reportPeriod")

        # @return [String] The selling program.
        attribute(:selling_program, String, from: "sellingProgram")
      end
    end
  end
end
