# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module VendorCoupon
      # This report contains data to help vendors optimize their coupons and adjust their advertising strategies. This
      # report supports start dates up to two years before the current date.
      Report = Structure.new do
        # @return [Array<DetailsByCampaign>] List of included campaigns.
        attribute(:campaigns, [DetailsByCampaign], null: false)

        # @return [Hash] Summarizes the original report request.
        attribute(:report_specification, ReportSpecification, null: false, from: "reportSpecification")
      end
    end
  end
end
