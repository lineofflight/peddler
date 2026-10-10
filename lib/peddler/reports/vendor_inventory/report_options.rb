# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module VendorInventory
      # Report options specifying parameters such as reportPeriod, distributorView, and sellingProgram.
      ReportOptions = Structure.new do
        # The distributor view.
        attribute(:distributor_view, String, null: false, from: "distributorView")

        # Determines what granularity of data is expected in the report. Valid values are: DAY, WEEK, MONTH, QUARTER,
        # YEAR.
        attribute(:report_period, String, null: false, from: "reportPeriod")

        # The selling program.
        attribute(:selling_program, String, null: false, from: "sellingProgram")
      end
    end
  end
end
