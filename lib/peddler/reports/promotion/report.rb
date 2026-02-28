# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module Promotion
      # The Promotion Performance report contains data to help vendors optimize their promotions and adjust their
      # advertising strategies. Currently three promotion types are supported: Best Deal, Lightning Deal, and Price
      # Discount. This report supports start dates up to two years before the current date.
      Report = Structure.new do
        # @return [Array<DetailsByPromotion>] The list of included promotions.
        attribute(:promotions, [DetailsByPromotion], null: false)

        # @return [Hash] Summarizes the original report request.
        attribute(:report_specification, ReportSpecification, null: false, from: "reportSpecification")
      end
    end
  end
end
