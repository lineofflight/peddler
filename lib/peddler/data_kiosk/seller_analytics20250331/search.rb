# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # Search metric group for search-related analytics.
      Search = Structure.new do
        # @return [SearchCatalogMetrics] Catalog-level search metrics aggregated across all keywords.
        attribute?(:catalog, SearchCatalogMetrics)

        # @return [Array<SearchQueryMetrics>] Query-level search metrics grouped by search keywords.
        # Returns an array of metrics per unique keyword within the current grouping context.
        attribute?(:query, [SearchQueryMetrics])
      end
    end
  end
end
