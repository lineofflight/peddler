# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellingPartnerSearchTerms
      # The Search Terms report shares data on the top-3 clicked ASINs by search keyword and department for a
      # marketplace. Data is available at different date range aggregation levels: DAY, WEEK, MONTH, QUARTER. Requests
      # cannot span multiple periods. For example, a request at WEEK level could not start on 2021-06-06 and end on
      # 2021-06-19 as this would span two weeks.
      Report = Structure.new do
        # @return [Array<DetailsByDepartmentAndSearchTerm>]
        attribute(:data_by_department_and_search_term, [DetailsByDepartmentAndSearchTerm], null: false, from: "dataByDepartmentAndSearchTerm")

        # @return [Hash] Summarizes the original report request.
        attribute(:report_specification, ReportSpecification, null: false, from: "reportSpecification")
      end
    end
  end
end
