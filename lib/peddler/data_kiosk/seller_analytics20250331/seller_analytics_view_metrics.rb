# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # Metrics broken down by metric groups, for example, Sales, Traffic, Promotion, AccountHealth, Lending, Search.
      SellerAnalyticsViewMetrics = Structure.new do
        # Account Health metric group.
        attribute?(:account_health, AccountHealth, from: "accountHealth")

        # Defects metric group.
        attribute?(:defects, Defects)

        # Lending metric group.
        attribute?(:lending, Lending)

        # Promotion metric group.
        attribute?(:promotion, Promotion)

        # Returns metric group.
        attribute?(:returns, Returns)

        # Reviews metric group.
        attribute?(:reviews, Reviews)

        # Sales metric group.
        attribute?(:sales, Sales)

        # Search metric group.
        attribute?(:search, Search)

        # Traffic metric group.
        attribute?(:traffic, Traffic)
      end
    end
  end
end
