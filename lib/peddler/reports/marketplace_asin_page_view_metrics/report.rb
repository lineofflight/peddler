# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module MarketplaceASINPageViewMetrics
      # Provides information on the ASIN page view (glance view) metrics for the DE, FR, IT, ES, NL, PL, SE, BE (EU-8)
      # and UK marketplaces, with data available up to the last seven days. A page view is a customer view of the
      # product's detail page for a given ASIN. Developers have the option to specify a start and end date to retrieve
      # data within that range. If no dates are specified, the report will provide the data for the latest available
      # day. For marketplaces and product categories where the seller does not have a meaningful presence (40 units
      # sold), the report will not return any data.
      Report = Structure.new do
        # @return [Array<MarketplaceAsinPageViewMetrics>] A list of ASIN page view metrics.
        attribute(:marketplace_asin_page_view_metrics, [MarketplaceASINPageViewMetrics], from: "marketplaceAsinPageViewMetrics")

        # @return [Hash] Summarizes the report request.
        attribute(:report_specification, ReportSpecification, from: "reportSpecification")
      end
    end
  end
end
