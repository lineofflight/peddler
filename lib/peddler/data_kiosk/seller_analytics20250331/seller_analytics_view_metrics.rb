# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # Metrics broken down by metric groups, for example, Sales, Traffic, Promotion, AccountHealth, Lending, Search.
      SellerAnalyticsViewMetrics = Structure.new do
        # @return [AccountHealth] Account Health metric group.
        attribute?(:account_health, AccountHealth, from: "accountHealth")

        # @return [Defects] Defects metric group.
        attribute?(:defects, Defects)

        # @return [Lending] Lending metric group.
        attribute?(:lending, Lending)

        # @return [Promotion] Promotion metric group.
        attribute?(:promotion, Promotion)

        # @return [Returns] Returns metric group.
        attribute?(:returns, Returns)

        # @return [Reviews] Reviews metric group.
        attribute?(:reviews, Reviews)

        # @return [Sales] Sales metric group.
        attribute?(:sales, Sales)

        # @return [Search] Search metric group.
        attribute?(:search, Search)

        # @return [Traffic] Traffic metric group.
        attribute?(:traffic, Traffic)
      end
    end
  end
end
